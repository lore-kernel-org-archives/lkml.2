Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab0KQE7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:59:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45507 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0KQE7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:59:45 -0500
Date: Tue, 16 Nov 2010 21:59:35 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: John Bonesio <bones@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, jdl@jdl.com,
        glikely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        david@gibson.dropbear.id.au
Subject: Re: [PATCH 1/5] scripts: dtc: Merge in changes from the dtc
 repository
Message-ID: <20101117045935.GA12084@angua.secretlab.ca>
References: <20101116204917.12146.39851.stgit@riker>
 <20101116204951.12146.21084.stgit@riker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116204951.12146.21084.stgit@riker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 12:49:51PM -0800, John Bonesio wrote:
> Pull in recent changes from the main dtc repository. These changes primarily
> allow multiple device trees to be declared which are merged by dtc. This
> feature allows us to include a basic dts file and then provide more information
> for the specific system through the merging functionality.
> 
> Signed-off-by: John Bonesio <bones@secretlab.ca>

Jon & David, I'll need your input on whether or not this is the best
way to handle updating the dtc copy in the kernel tree.

g.

> ---
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
> index 01cdb36..04a31c1 100644
> --- a/scripts/dtc/Makefile
> +++ b/scripts/dtc/Makefile
> @@ -4,7 +4,7 @@ hostprogs-y	:= dtc
>  always		:= $(hostprogs-y)
>  
>  dtc-objs	:= dtc.o flattree.o fstree.o data.o livetree.o treesource.o \
> -		   srcpos.o checks.o
> +		   srcpos.o checks.o util.o
>  dtc-objs	+= dtc-lexer.lex.o dtc-parser.tab.o
>  
>  # Source files need to get at the userspace version of libfdt_env.h to compile
> @@ -19,6 +19,7 @@ HOSTCFLAGS_fstree.o := $(HOSTCFLAGS_DTC)
>  HOSTCFLAGS_livetree.o := $(HOSTCFLAGS_DTC)
>  HOSTCFLAGS_srcpos.o := $(HOSTCFLAGS_DTC)
>  HOSTCFLAGS_treesource.o := $(HOSTCFLAGS_DTC)
> +HOSTCFLAGS_util.o := $(HOSTCFLAGS_DTC)
>  
>  HOSTCFLAGS_dtc-lexer.lex.o := $(HOSTCFLAGS_DTC)
>  HOSTCFLAGS_dtc-parser.tab.o := $(HOSTCFLAGS_DTC)
> diff --git a/scripts/dtc/checks.c b/scripts/dtc/checks.c
> index 9548579..a662a00 100644
> --- a/scripts/dtc/checks.c
> +++ b/scripts/dtc/checks.c
> @@ -278,32 +278,112 @@ static void check_property_name_chars(struct check *c, struct node *dt,
>  }
>  PROP_CHECK(property_name_chars, PROPNODECHARS, ERROR);
>  
> +#define DESCLABEL_FMT	"%s%s%s%s%s"
> +#define DESCLABEL_ARGS(node,prop,mark)		\
> +	((mark) ? "value of " : ""),		\
> +	((prop) ? "'" : ""), \
> +	((prop) ? (prop)->name : ""), \
> +	((prop) ? "' in " : ""), (node)->fullpath
> +
> +static void check_duplicate_label(struct check *c, struct node *dt,
> +				  const char *label, struct node *node,
> +				  struct property *prop, struct marker *mark)
> +{
> +	struct node *othernode = NULL;
> +	struct property *otherprop = NULL;
> +	struct marker *othermark = NULL;
> +
> +	othernode = get_node_by_label(dt, label);
> +
> +	if (!othernode)
> +		otherprop = get_property_by_label(dt, label, &othernode);
> +	if (!othernode)
> +		othermark = get_marker_label(dt, label, &othernode,
> +					       &otherprop);
> +
> +	if (!othernode)
> +		return;
> +
> +	if ((othernode != node) || (otherprop != prop) || (othermark != mark))
> +		FAIL(c, "Duplicate label '%s' on " DESCLABEL_FMT
> +		     " and " DESCLABEL_FMT,
> +		     label, DESCLABEL_ARGS(node, prop, mark),
> +		     DESCLABEL_ARGS(othernode, otherprop, othermark));
> +}
> +
> +static void check_duplicate_label_node(struct check *c, struct node *dt,
> +				       struct node *node)
> +{
> +	struct label *l;
> +
> +	for_each_label(node->labels, l)
> +		check_duplicate_label(c, dt, l->label, node, NULL, NULL);
> +}
> +static void check_duplicate_label_prop(struct check *c, struct node *dt,
> +				       struct node *node, struct property *prop)
> +{
> +	struct marker *m = prop->val.markers;
> +	struct label *l;
> +
> +	for_each_label(prop->labels, l)
> +		check_duplicate_label(c, dt, l->label, node, prop, NULL);
> +
> +	for_each_marker_of_type(m, LABEL)
> +		check_duplicate_label(c, dt, m->ref, node, prop, m);
> +}
> +CHECK(duplicate_label, NULL, check_duplicate_label_node,
> +      check_duplicate_label_prop, NULL, ERROR);
> +
>  static void check_explicit_phandles(struct check *c, struct node *root,
> -					  struct node *node)
> +				    struct node *node, struct property *prop)
>  {
> -	struct property *prop;
> +	struct marker *m;
>  	struct node *other;
>  	cell_t phandle;
>  
> -	prop = get_property(node, "linux,phandle");
> -	if (! prop)
> -		return; /* No phandle, that's fine */
> +	if (!streq(prop->name, "phandle")
> +	    && !streq(prop->name, "linux,phandle"))
> +		return;
>  
>  	if (prop->val.len != sizeof(cell_t)) {
> -		FAIL(c, "%s has bad length (%d) linux,phandle property",
> -		     node->fullpath, prop->val.len);
> +		FAIL(c, "%s has bad length (%d) %s property",
> +		     node->fullpath, prop->val.len, prop->name);
> +		return;
> +	}
> +
> +	m = prop->val.markers;
> +	for_each_marker_of_type(m, REF_PHANDLE) {
> +		assert(m->offset == 0);
> +		if (node != get_node_by_ref(root, m->ref))
> +			/* "Set this node's phandle equal to some
> +			 * other node's phandle".  That's nonsensical
> +			 * by construction. */ {
> +			FAIL(c, "%s in %s is a reference to another node",
> +			     prop->name, node->fullpath);
> +			return;
> +		}
> +		/* But setting this node's phandle equal to its own
> +		 * phandle is allowed - that means allocate a unique
> +		 * phandle for this node, even if it's not otherwise
> +		 * referenced.  The value will be filled in later, so
> +		 * no further checking for now. */
>  		return;
>  	}
>  
>  	phandle = propval_cell(prop);
> +
>  	if ((phandle == 0) || (phandle == -1)) {
> -		FAIL(c, "%s has invalid linux,phandle value 0x%x",
> -		     node->fullpath, phandle);
> +		FAIL(c, "%s has bad value (0x%x) in %s property",
> +		     node->fullpath, phandle, prop->name);
>  		return;
>  	}
>  
> +	if (node->phandle && (node->phandle != phandle))
> +		FAIL(c, "%s has %s property which replaces existing phandle information",
> +		     node->fullpath, prop->name);
> +
>  	other = get_node_by_phandle(root, phandle);
> -	if (other) {
> +	if (other && (other != node)) {
>  		FAIL(c, "%s has duplicated phandle 0x%x (seen before at %s)",
>  		     node->fullpath, phandle, other->fullpath);
>  		return;
> @@ -311,7 +391,7 @@ static void check_explicit_phandles(struct check *c, struct node *root,
>  
>  	node->phandle = phandle;
>  }
> -NODE_CHECK(explicit_phandles, NULL, ERROR);
> +PROP_CHECK(explicit_phandles, NULL, ERROR);
>  
>  static void check_name_properties(struct check *c, struct node *root,
>  				  struct node *node)
> @@ -549,6 +629,9 @@ static struct check *check_table[] = {
>  	&duplicate_node_names, &duplicate_property_names,
>  	&node_name_chars, &node_name_format, &property_name_chars,
>  	&name_is_string, &name_properties,
> +
> +	&duplicate_label,
> +
>  	&explicit_phandles,
>  	&phandle_references, &path_references,
>  
> diff --git a/scripts/dtc/dtc-lexer.l b/scripts/dtc/dtc-lexer.l
> index a627bbe..e866ea5 100644
> --- a/scripts/dtc/dtc-lexer.l
> +++ b/scripts/dtc/dtc-lexer.l
> @@ -18,7 +18,7 @@
>   *                                                                   USA
>   */
>  
> -%option noyywrap noinput nounput yylineno
> +%option noyywrap nounput noinput never-interactive
>  
>  %x INCLUDE
>  %x BYTESTRING
> @@ -38,6 +38,13 @@ LINECOMMENT	"//".*\n
>  #include "srcpos.h"
>  #include "dtc-parser.tab.h"
>  
> +YYLTYPE yylloc;
> +
> +/* CAUTION: this will stop working if we ever use yyless() or yyunput() */
> +#define	YY_USER_ACTION \
> +	{ \
> +		srcpos_update(&yylloc, yytext, yyleng); \
> +	}
>  
>  /*#define LEXDEBUG	1*/
>  
> @@ -47,15 +54,10 @@ LINECOMMENT	"//".*\n
>  #define DPRINT(fmt, ...)	do { } while (0)
>  #endif
>  
> -static int dts_version; /* = 0 */
> +static int dts_version = 1;
>  
> -#define BEGIN_DEFAULT()	if (dts_version == 0) { \
> -				DPRINT("<INITIAL>\n"); \
> -				BEGIN(INITIAL); \
> -			} else { \
> -				DPRINT("<V1>\n"); \
> +#define BEGIN_DEFAULT()		DPRINT("<V1>\n"); \
>  				BEGIN(V1); \
> -			}
>  
>  static void push_input_file(const char *filename);
>  static int pop_input_file(void);
> @@ -75,18 +77,13 @@ static int pop_input_file(void);
>  		}
>  
>  <*>{STRING}	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("String: %s\n", yytext);
>  			yylval.data = data_copy_escape_string(yytext+1,
>  					yyleng-2);
> -			yylloc.first_line = yylineno;
>  			return DT_STRING;
>  		}
>  
>  <*>"/dts-v1/"	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Keyword: /dts-v1/\n");
>  			dts_version = 1;
>  			BEGIN_DEFAULT();
> @@ -94,106 +91,57 @@ static int pop_input_file(void);
>  		}
>  
>  <*>"/memreserve/"	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Keyword: /memreserve/\n");
>  			BEGIN_DEFAULT();
>  			return DT_MEMRESERVE;
>  		}
>  
>  <*>{LABEL}:	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Label: %s\n", yytext);
> -			yylval.labelref = strdup(yytext);
> +			yylval.labelref = xstrdup(yytext);
>  			yylval.labelref[yyleng-1] = '\0';
>  			return DT_LABEL;
>  		}
>  
> -<INITIAL>[bodh]# {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			if (*yytext == 'b')
> -				yylval.cbase = 2;
> -			else if (*yytext == 'o')
> -				yylval.cbase = 8;
> -			else if (*yytext == 'd')
> -				yylval.cbase = 10;
> -			else
> -				yylval.cbase = 16;
> -			DPRINT("Base: %d\n", yylval.cbase);
> -			return DT_BASE;
> -		}
> -
> -<INITIAL>[0-9a-fA-F]+	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			yylval.literal = strdup(yytext);
> -			DPRINT("Literal: '%s'\n", yylval.literal);
> -			return DT_LEGACYLITERAL;
> -		}
> -
>  <V1>[0-9]+|0[xX][0-9a-fA-F]+      {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			yylval.literal = strdup(yytext);
> +			yylval.literal = xstrdup(yytext);
>  			DPRINT("Literal: '%s'\n", yylval.literal);
>  			return DT_LITERAL;
>  		}
>  
> -\&{LABEL}	{	/* label reference */
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> +<*>\&{LABEL}	{	/* label reference */
>  			DPRINT("Ref: %s\n", yytext+1);
> -			yylval.labelref = strdup(yytext+1);
> +			yylval.labelref = xstrdup(yytext+1);
>  			return DT_REF;
>  		}
>  
> -"&{/"{PATHCHAR}+\}	{	/* new-style path reference */
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> +<*>"&{/"{PATHCHAR}+\}	{	/* new-style path reference */
>  			yytext[yyleng-1] = '\0';
>  			DPRINT("Ref: %s\n", yytext+2);
> -			yylval.labelref = strdup(yytext+2);
> -			return DT_REF;
> -		}
> -
> -<INITIAL>"&/"{PATHCHAR}+ {	/* old-style path reference */
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			DPRINT("Ref: %s\n", yytext+1);
> -			yylval.labelref = strdup(yytext+1);
> +			yylval.labelref = xstrdup(yytext+2);
>  			return DT_REF;
>  		}
>  
>  <BYTESTRING>[0-9a-fA-F]{2} {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			yylval.byte = strtol(yytext, NULL, 16);
>  			DPRINT("Byte: %02x\n", (int)yylval.byte);
>  			return DT_BYTE;
>  		}
>  
>  <BYTESTRING>"]"	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("/BYTESTRING\n");
>  			BEGIN_DEFAULT();
>  			return ']';
>  		}
>  
>  <PROPNODENAME>{PROPNODECHAR}+ {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("PropNodeName: %s\n", yytext);
> -			yylval.propnodename = strdup(yytext);
> +			yylval.propnodename = xstrdup(yytext);
>  			BEGIN_DEFAULT();
>  			return DT_PROPNODENAME;
>  		}
>  
>  "/incbin/"	{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Binary Include\n");
>  			return DT_INCBIN;
>  		}
> @@ -203,8 +151,6 @@ static int pop_input_file(void);
>  <*>{LINECOMMENT}+ /* eat C++-style comments */
>  
>  <*>.		{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Char: %c (\\x%02x)\n", yytext[0],
>  				(unsigned)yytext[0]);
>  			if (yytext[0] == '[') {
> @@ -221,100 +167,25 @@ static int pop_input_file(void);
>  
>  %%
>  
> -
> -/*
> - * Stack of nested include file contexts.
> - */
> -
> -struct incl_file {
> -	struct dtc_file *file;
> -	YY_BUFFER_STATE yy_prev_buf;
> -	int yy_prev_lineno;
> -	struct incl_file *prev;
> -};
> -
> -static struct incl_file *incl_file_stack;
> -
> -
> -/*
> - * Detect infinite include recursion.
> - */
> -#define MAX_INCLUDE_DEPTH	(100)
> -
> -static int incl_depth = 0;
> -
> -
>  static void push_input_file(const char *filename)
>  {
> -	struct incl_file *incl_file;
> -	struct dtc_file *newfile;
> -	struct search_path search, *searchptr = NULL;
> -
>  	assert(filename);
>  
> -	if (incl_depth++ >= MAX_INCLUDE_DEPTH)
> -		die("Includes nested too deeply");
> -
> -	if (srcpos_file) {
> -		search.dir = srcpos_file->dir;
> -		search.next = NULL;
> -		search.prev = NULL;
> -		searchptr = &search;
> -	}
> -
> -	newfile = dtc_open_file(filename, searchptr);
> +	srcfile_push(filename);
>  
> -	incl_file = xmalloc(sizeof(struct incl_file));
> +	yyin = current_srcfile->f;
>  
> -	/*
> -	 * Save current context.
> -	 */
> -	incl_file->yy_prev_buf = YY_CURRENT_BUFFER;
> -	incl_file->yy_prev_lineno = yylineno;
> -	incl_file->file = srcpos_file;
> -	incl_file->prev = incl_file_stack;
> -
> -	incl_file_stack = incl_file;
> -
> -	/*
> -	 * Establish new context.
> -	 */
> -	srcpos_file = newfile;
> -	yylineno = 1;
> -	yyin = newfile->file;
> -	yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
> +	yypush_buffer_state(yy_create_buffer(yyin, YY_BUF_SIZE));
>  }
>  
>  
>  static int pop_input_file(void)
>  {
> -	struct incl_file *incl_file;
> -
> -	if (incl_file_stack == 0)
> +	if (srcfile_pop() == 0)
>  		return 0;
>  
> -	dtc_close_file(srcpos_file);
> -
> -	/*
> -	 * Pop.
> -	 */
> -	--incl_depth;
> -	incl_file = incl_file_stack;
> -	incl_file_stack = incl_file->prev;
> -
> -	/*
> -	 * Recover old context.
> -	 */
> -	yy_delete_buffer(YY_CURRENT_BUFFER);
> -	yy_switch_to_buffer(incl_file->yy_prev_buf);
> -	yylineno = incl_file->yy_prev_lineno;
> -	srcpos_file = incl_file->file;
> -	yyin = incl_file->file ? incl_file->file->file : NULL;
> -
> -	/*
> -	 * Free old state.
> -	 */
> -	free(incl_file);
> +	yypop_buffer_state();
> +	yyin = current_srcfile->f;
>  
>  	return 1;
>  }
> diff --git a/scripts/dtc/dtc-lexer.lex.c_shipped b/scripts/dtc/dtc-lexer.lex.c_shipped
> index e27cc63..50c4420 100644
> --- a/scripts/dtc/dtc-lexer.lex.c_shipped
> +++ b/scripts/dtc/dtc-lexer.lex.c_shipped
> @@ -170,20 +170,7 @@ extern FILE *yyin, *yyout;
>  #define EOB_ACT_END_OF_FILE 1
>  #define EOB_ACT_LAST_MATCH 2
>  
> -    /* Note: We specifically omit the test for yy_rule_can_match_eol because it requires
> -     *       access to the local variable yy_act. Since yyless() is a macro, it would break
> -     *       existing scanners that call yyless() from OUTSIDE yylex. 
> -     *       One obvious solution it to make yy_act a global. I tried that, and saw
> -     *       a 5% performance hit in a non-yylineno scanner, because yy_act is
> -     *       normally declared as a register variable-- so it is not worth it.
> -     */
> -    #define  YY_LESS_LINENO(n) \
> -            do { \
> -                int yyl;\
> -                for ( yyl = n; yyl < yyleng; ++yyl )\
> -                    if ( yytext[yyl] == '\n' )\
> -                        --yylineno;\
> -            }while(0)
> +    #define YY_LESS_LINENO(n)
>      
>  /* Return all but the first "n" matched characters back to the input stream. */
>  #define yyless(n) \
> @@ -385,8 +372,8 @@ static void yy_fatal_error (yyconst char msg[]  );
>  	*yy_cp = '\0'; \
>  	(yy_c_buf_p) = yy_cp;
>  
> -#define YY_NUM_RULES 20
> -#define YY_END_OF_BUFFER 21
> +#define YY_NUM_RULES 17
> +#define YY_END_OF_BUFFER 18
>  /* This struct is not used in this scanner,
>     but its presence is necessary. */
>  struct yy_trans_info
> @@ -394,20 +381,19 @@ struct yy_trans_info
>  	flex_int32_t yy_verify;
>  	flex_int32_t yy_nxt;
>  	};
> -static yyconst flex_int16_t yy_accept[104] =
> +static yyconst flex_int16_t yy_accept[94] =
>      {   0,
>          0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
> -       21,   19,   16,   16,   19,   19,   19,    7,    7,   19,
> -        7,   19,   19,   19,   19,   13,   14,   14,   19,    8,
> -        8,   16,    0,    2,    0,    0,    9,    0,    0,    0,
> -        0,    0,    0,    7,    7,    5,    0,    6,    0,   12,
> -       12,   14,   14,    8,    0,   11,    9,    0,    0,    0,
> -        0,   18,    0,    0,    0,    0,    8,    0,   17,    0,
> -        0,    0,    0,    0,   10,    0,    0,    0,    0,    0,
> -        0,    0,    0,    0,    0,    0,    0,    0,    3,   15,
> +       18,   16,   13,   13,   16,   16,   16,   16,   16,   16,
> +       16,   10,   11,   11,    6,    6,   13,    0,    2,    0,
> +        7,    0,    0,    0,    0,    0,    0,    0,    5,    0,
> +        9,    9,   11,   11,    6,    0,    7,    0,    0,    0,
> +        0,   15,    0,    0,    0,    0,    6,    0,   14,    0,
> +        0,    0,    0,    0,    8,    0,    0,    0,    0,    0,
> +        0,    0,    0,    0,    0,    0,    0,    0,    3,   12,
>          0,    0,    0,    0,    0,    0,    0,    0,    1,    0,
> -
>          0,    4,    0
> +
>      } ;
>  
>  static yyconst flex_int32_t yy_ec[256] =
> @@ -416,16 +402,16 @@ static yyconst flex_int32_t yy_ec[256] =
>          2,    2,    2,    1,    1,    1,    1,    1,    1,    1,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
>          1,    2,    1,    4,    5,    1,    1,    6,    1,    1,
> -        1,    7,    8,    8,    9,    8,   10,   11,   12,   13,
> -       13,   13,   13,   13,   13,   13,   13,   14,    1,    1,
> -        1,    1,    8,    8,   15,   15,   15,   15,   15,   15,
> -       16,   16,   16,   16,   16,   16,   16,   16,   16,   16,
> -       16,   16,   16,   16,   16,   16,   16,   17,   16,   16,
> -        1,   18,   19,    1,   16,    1,   15,   20,   21,   22,
> -
> -       23,   15,   16,   24,   25,   16,   16,   26,   27,   28,
> -       24,   16,   16,   29,   30,   31,   32,   33,   16,   17,
> -       16,   16,   34,    1,   35,    1,    1,    1,    1,    1,
> +        1,    7,    5,    5,    8,    5,    9,   10,   11,   12,
> +       12,   12,   12,   12,   12,   12,   12,   13,    1,    1,
> +        1,    1,    5,    5,   14,   14,   14,   14,   14,   14,
> +       15,   15,   15,   15,   15,   15,   15,   15,   15,   15,
> +       15,   15,   15,   15,   15,   15,   15,   16,   15,   15,
> +        1,   17,   18,    1,   15,    1,   14,   19,   20,   21,
> +
> +       22,   14,   15,   15,   23,   15,   15,   24,   25,   26,
> +       15,   15,   15,   27,   28,   29,   30,   31,   15,   16,
> +       15,   15,   32,    1,   33,    1,    1,    1,    1,    1,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
> @@ -442,136 +428,114 @@ static yyconst flex_int32_t yy_ec[256] =
>          1,    1,    1,    1,    1
>      } ;
>  
> -static yyconst flex_int32_t yy_meta[36] =
> +static yyconst flex_int32_t yy_meta[34] =
>      {   0,
> -        1,    1,    1,    1,    2,    1,    2,    2,    2,    3,
> -        4,    4,    4,    5,    6,    7,    7,    1,    1,    6,
> -        6,    6,    6,    7,    7,    7,    7,    7,    7,    7,
> -        7,    7,    7,    8,    1
> +        1,    1,    1,    1,    2,    1,    2,    2,    3,    4,
> +        4,    4,    5,    6,    7,    7,    1,    1,    6,    6,
> +        6,    6,    7,    7,    7,    7,    7,    7,    7,    7,
> +        7,    8,    1
>      } ;
>  
> -static yyconst flex_int16_t yy_base[117] =
> +static yyconst flex_int16_t yy_base[106] =
>      {   0,
> -        0,    0,   30,    0,   44,    0,   67,    0,   97,  105,
> -      302,  303,   35,   44,   40,   94,  112,    0,  129,  152,
> -      296,  295,  159,    0,  176,  303,    0,  116,   95,  165,
> -       49,   46,  102,  303,  296,    0,    0,  288,  290,  293,
> -      264,  266,  270,    0,    0,  303,    0,  303,  264,  303,
> -        0,    0,  195,  101,    0,    0,    0,    0,  284,  125,
> -      277,  265,  225,  230,  216,  218,    0,  202,  224,  221,
> -      217,  107,  196,  188,  303,  206,  179,  186,  178,  185,
> -      183,  162,  161,  150,  169,  160,  145,  125,  303,  303,
> -      137,  109,  190,  103,  203,  167,  108,  197,  303,  123,
> -
> -       29,  303,  303,  215,  221,  226,  229,  234,  240,  246,
> -      250,  257,  265,  270,  275,  282
> +        0,    0,  237,  236,   25,    0,   47,    0,   30,   71,
> +      244,  247,   82,   84,   84,  211,   95,  229,  218,    0,
> +      111,  247,    0,   84,   83,   95,  106,   86,  247,  237,
> +        0,  230,  231,  234,  207,  209,  212,  220,  247,  206,
> +      247,  218,    0,  106,  116,    0,    0,    0,  223,   89,
> +      226,  219,  199,  206,  200,  204,    0,  190,  213,  212,
> +      202,   91,  178,  161,  247,  172,  144,  150,  140,  130,
> +      140,  124,  128,  120,  138,  137,  123,  122,  247,  247,
> +      134,  114,  132,   86,  135,  125,   90,  136,  247,   97,
> +       29,  247,  247,  153,  156,  161,  165,  170,  176,  180,
> +
> +      187,  195,  200,  205,  212
>      } ;
>  
> -static yyconst flex_int16_t yy_def[117] =
> +static yyconst flex_int16_t yy_def[106] =
>      {   0,
> -      103,    1,    1,    3,    3,    5,  103,    7,    3,    3,
> -      103,  103,  103,  103,  104,  105,  103,  106,  103,   19,
> -       19,   20,  103,  107,   20,  103,  108,  109,  105,  103,
> -      103,  103,  104,  103,  104,  110,  111,  103,  112,  113,
> -      103,  103,  103,  106,   19,  103,   20,  103,  103,  103,
> -       20,  108,  109,  103,  114,  110,  111,  115,  112,  112,
> -      113,  103,  103,  103,  103,  103,  114,  115,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  116,  103,  116,  103,  116,
> -
> -      103,  103,    0,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103
> +       93,    1,    1,    1,    1,    5,   93,    7,    1,    1,
> +       93,   93,   93,   93,   94,   95,   93,   96,   17,   97,
> +       96,   93,   98,   99,   93,   93,   93,   94,   93,   94,
> +      100,   93,  101,  102,   93,   93,   93,   96,   93,   93,
> +       93,   96,   98,   99,   93,  103,  100,  104,  101,  101,
> +      102,   93,   93,   93,   93,   93,  103,  104,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,  105,   93,  105,   93,  105,
> +       93,   93,    0,   93,   93,   93,   93,   93,   93,   93,
> +
> +       93,   93,   93,   93,   93
>      } ;
>  
> -static yyconst flex_int16_t yy_nxt[339] =
> +static yyconst flex_int16_t yy_nxt[281] =
>      {   0,
> -       12,   13,   14,   15,   12,   16,   12,   12,   12,   17,
> -       18,   18,   18,   12,   19,   20,   20,   12,   12,   21,
> -       19,   21,   19,   22,   20,   20,   20,   20,   20,   20,
> -       20,   20,   20,   12,   12,   12,   32,   32,  102,   23,
> -       12,   12,   12,   34,   20,   32,   32,   32,   32,   20,
> -       20,   20,   20,   20,   24,   24,   24,   35,   25,   54,
> -       54,   54,   26,   25,   25,   25,   25,   12,   13,   14,
> -       15,   27,   12,   27,   27,   27,   23,   27,   27,   27,
> -       12,   28,   28,   28,   12,   12,   28,   28,   28,   28,
> -       28,   28,   28,   28,   28,   28,   28,   28,   28,   28,
> -
> -       12,   12,   29,   36,  103,   34,   17,   30,   31,   31,
> -       29,   54,   54,   54,   17,   30,   31,   31,   39,   35,
> -       52,   40,   52,   52,   52,  103,   78,   38,   38,   46,
> -      101,   60,   79,   41,   69,   97,   42,   94,   43,   45,
> -       45,   45,   46,   45,   47,   47,   93,   92,   45,   45,
> -       45,   45,   47,   47,   47,   47,   47,   47,   47,   47,
> -       47,   47,   47,   47,   47,   39,   47,   91,   40,   90,
> -       99,   47,   47,   47,   47,   54,   54,   54,   89,   88,
> -       41,   55,   87,   49,  100,   43,   51,   51,   51,   86,
> -       51,   95,   95,   96,   85,   51,   51,   51,   51,   52,
> -
> -       99,   52,   52,   52,   95,   95,   96,   84,   46,   83,
> -       82,   81,   39,   79,  100,   33,   33,   33,   33,   33,
> -       33,   33,   33,   37,   80,   77,   37,   37,   37,   44,
> -       40,   44,   50,   76,   50,   52,   75,   52,   74,   52,
> -       52,   53,   73,   53,   53,   53,   53,   56,   56,   56,
> -       72,   56,   56,   57,   71,   57,   57,   59,   59,   59,
> -       59,   59,   59,   59,   59,   61,   61,   61,   61,   61,
> -       61,   61,   61,   67,   70,   67,   68,   68,   68,   62,
> -       68,   68,   98,   98,   98,   98,   98,   98,   98,   98,
> -       60,   66,   65,   64,   63,   62,   60,   58,  103,   48,
> -
> -       48,  103,   11,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103
> +       12,   13,   14,   15,   12,   16,   12,   12,   17,   12,
> +       12,   12,   12,   18,   18,   18,   12,   12,   18,   18,
> +       18,   18,   18,   18,   18,   18,   18,   18,   18,   18,
> +       18,   12,   12,   19,   20,   20,   20,   92,   21,   25,
> +       26,   26,   22,   21,   21,   21,   21,   12,   13,   14,
> +       15,   23,   16,   23,   23,   19,   23,   23,   23,   12,
> +       24,   24,   24,   12,   12,   24,   24,   24,   24,   24,
> +       24,   24,   24,   24,   24,   24,   24,   24,   12,   12,
> +       25,   26,   26,   27,   27,   27,   27,   29,   43,   29,
> +       43,   43,   45,   45,   45,   50,   39,   59,   46,   93,
> +
> +       30,   33,   30,   34,   45,   45,   45,   27,   27,   68,
> +       43,   91,   43,   43,   69,   35,   87,   36,   39,   37,
> +       42,   42,   42,   39,   42,   45,   45,   45,   89,   42,
> +       42,   42,   42,   85,   85,   86,   85,   85,   86,   89,
> +       84,   90,   83,   82,   81,   80,   79,   78,   77,   76,
> +       75,   74,   90,   28,   28,   28,   28,   28,   28,   28,
> +       28,   31,   31,   31,   38,   38,   38,   38,   41,   73,
> +       41,   43,   72,   43,   71,   43,   43,   44,   33,   44,
> +       44,   44,   44,   47,   69,   47,   47,   49,   49,   49,
> +       49,   49,   49,   49,   49,   51,   51,   51,   51,   51,
> +
> +       51,   51,   51,   57,   70,   57,   58,   58,   58,   67,
> +       58,   58,   88,   88,   88,   88,   88,   88,   88,   88,
> +       34,   66,   65,   64,   63,   62,   61,   60,   52,   50,
> +       39,   56,   39,   55,   54,   53,   52,   50,   48,   93,
> +       40,   39,   32,   93,   19,   19,   11,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93
>      } ;
>  
> -static yyconst flex_int16_t yy_chk[339] =
> +static yyconst flex_int16_t yy_chk[281] =
>      {   0,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
>          1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
> -        1,    1,    1,    1,    1,    3,   13,   13,  101,    3,
> -        3,    3,    3,   15,    3,   14,   14,   32,   32,    3,
> -        3,    3,    3,    3,    5,    5,    5,   15,    5,   31,
> -       31,   31,    5,    5,    5,    5,    5,    7,    7,    7,
> +        1,    1,    1,    5,    5,    5,    5,   91,    5,    9,
> +        9,    9,    5,    5,    5,    5,    5,    7,    7,    7,
>          7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
>          7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
>          7,    7,    7,    7,    7,    7,    7,    7,    7,    7,
> -
> -        7,    7,    9,   16,   29,   33,    9,    9,    9,    9,
> -       10,   54,   54,   54,   10,   10,   10,   10,   17,   33,
> -       28,   17,   28,   28,   28,  100,   72,   16,   29,   28,
> -       97,   60,   72,   17,   60,   94,   17,   92,   17,   19,
> -       19,   19,   19,   19,   19,   19,   91,   88,   19,   19,
> -       19,   19,   19,   19,   19,   19,   19,   19,   19,   19,
> -       19,   19,   20,   20,   20,   23,   20,   87,   23,   86,
> -       96,   20,   20,   20,   20,   30,   30,   30,   85,   84,
> -       23,   30,   83,   23,   96,   23,   25,   25,   25,   82,
> -       25,   93,   93,   93,   81,   25,   25,   25,   25,   53,
> -
> -       98,   53,   53,   53,   95,   95,   95,   80,   53,   79,
> -       78,   77,   76,   74,   98,  104,  104,  104,  104,  104,
> -      104,  104,  104,  105,   73,   71,  105,  105,  105,  106,
> -       70,  106,  107,   69,  107,  108,   68,  108,   66,  108,
> -      108,  109,   65,  109,  109,  109,  109,  110,  110,  110,
> -       64,  110,  110,  111,   63,  111,  111,  112,  112,  112,
> -      112,  112,  112,  112,  112,  113,  113,  113,  113,  113,
> -      113,  113,  113,  114,   62,  114,  115,  115,  115,   61,
> -      115,  115,  116,  116,  116,  116,  116,  116,  116,  116,
> -       59,   49,   43,   42,   41,   40,   39,   38,   35,   22,
> -
> -       21,   11,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103,  103,  103,
> -      103,  103,  103,  103,  103,  103,  103,  103
> +       10,   10,   10,   13,   13,   14,   14,   15,   24,   28,
> +       24,   24,   25,   25,   25,   50,   24,   50,   25,   90,
> +
> +       15,   17,   28,   17,   26,   26,   26,   27,   27,   62,
> +       44,   87,   44,   44,   62,   17,   84,   17,   44,   17,
> +       21,   21,   21,   21,   21,   45,   45,   45,   86,   21,
> +       21,   21,   21,   83,   83,   83,   85,   85,   85,   88,
> +       82,   86,   81,   78,   77,   76,   75,   74,   73,   72,
> +       71,   70,   88,   94,   94,   94,   94,   94,   94,   94,
> +       94,   95,   95,   95,   96,   96,   96,   96,   97,   69,
> +       97,   98,   68,   98,   67,   98,   98,   99,   66,   99,
> +       99,   99,   99,  100,   64,  100,  100,  101,  101,  101,
> +      101,  101,  101,  101,  101,  102,  102,  102,  102,  102,
> +
> +      102,  102,  102,  103,   63,  103,  104,  104,  104,   61,
> +      104,  104,  105,  105,  105,  105,  105,  105,  105,  105,
> +       60,   59,   58,   56,   55,   54,   53,   52,   51,   49,
> +       42,   40,   38,   37,   36,   35,   34,   33,   32,   30,
> +       19,   18,   16,   11,    4,    3,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
> +       93,   93,   93,   93,   93,   93,   93,   93,   93,   93
>      } ;
>  
> -/* Table of booleans, true if rule could match eol. */
> -static yyconst flex_int32_t yy_rule_can_match_eol[21] =
> -    {   0,
> -1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 
> -    0,     };
> -
>  static yy_state_type yy_last_accepting_state;
>  static char *yy_last_accepting_cpos;
>  
> @@ -616,6 +580,13 @@ char *yytext;
>  #include "srcpos.h"
>  #include "dtc-parser.tab.h"
>  
> +YYLTYPE yylloc;
> +
> +/* CAUTION: this will stop working if we ever use yyless() or yyunput() */
> +#define	YY_USER_ACTION \
> +	{ \
> +		srcpos_update(&yylloc, yytext, yyleng); \
> +	}
>  
>  /*#define LEXDEBUG	1*/
>  
> @@ -625,19 +596,14 @@ char *yytext;
>  #define DPRINT(fmt, ...)	do { } while (0)
>  #endif
>  
> -static int dts_version; /* = 0 */
> +static int dts_version = 1;
>  
> -#define BEGIN_DEFAULT()	if (dts_version == 0) { \
> -				DPRINT("<INITIAL>\n"); \
> -				BEGIN(INITIAL); \
> -			} else { \
> -				DPRINT("<V1>\n"); \
> +#define BEGIN_DEFAULT()		DPRINT("<V1>\n"); \
>  				BEGIN(V1); \
> -			}
>  
>  static void push_input_file(const char *filename);
>  static int pop_input_file(void);
> -#line 641 "dtc-lexer.lex.c"
> +#line 607 "dtc-lexer.lex.c"
>  
>  #define INITIAL 0
>  #define INCLUDE 1
> @@ -826,9 +792,9 @@ YY_DECL
>  	register char *yy_cp, *yy_bp;
>  	register int yy_act;
>      
> -#line 64 "dtc-lexer.l"
> +#line 66 "dtc-lexer.l"
>  
> -#line 832 "dtc-lexer.lex.c"
> +#line 798 "dtc-lexer.lex.c"
>  
>  	if ( !(yy_init) )
>  		{
> @@ -881,35 +847,21 @@ yy_match:
>  			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
>  				{
>  				yy_current_state = (int) yy_def[yy_current_state];
> -				if ( yy_current_state >= 104 )
> +				if ( yy_current_state >= 94 )
>  					yy_c = yy_meta[(unsigned int) yy_c];
>  				}
>  			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
>  			++yy_cp;
>  			}
> -		while ( yy_base[yy_current_state] != 303 );
> +		while ( yy_current_state != 93 );
> +		yy_cp = (yy_last_accepting_cpos);
> +		yy_current_state = (yy_last_accepting_state);
>  
>  yy_find_action:
>  		yy_act = yy_accept[yy_current_state];
> -		if ( yy_act == 0 )
> -			{ /* have to back up */
> -			yy_cp = (yy_last_accepting_cpos);
> -			yy_current_state = (yy_last_accepting_state);
> -			yy_act = yy_accept[yy_current_state];
> -			}
>  
>  		YY_DO_BEFORE_ACTION;
>  
> -		if ( yy_act != YY_END_OF_BUFFER && yy_rule_can_match_eol[yy_act] )
> -			{
> -			int yyl;
> -			for ( yyl = 0; yyl < yyleng; ++yyl )
> -				if ( yytext[yyl] == '\n' )
> -					   
> -    yylineno++;
> -;
> -			}
> -
>  do_action:	/* This label is used only to access EOF actions. */
>  
>  		switch ( yy_act )
> @@ -924,7 +876,7 @@ do_action:	/* This label is used only to access EOF actions. */
>  case 1:
>  /* rule 1 can match eol */
>  YY_RULE_SETUP
> -#line 65 "dtc-lexer.l"
> +#line 67 "dtc-lexer.l"
>  {
>  			char *name = strchr(yytext, '\"') + 1;
>  			yytext[yyleng-1] = '\0';
> @@ -936,7 +888,7 @@ case YY_STATE_EOF(INCLUDE):
>  case YY_STATE_EOF(BYTESTRING):
>  case YY_STATE_EOF(PROPNODENAME):
>  case YY_STATE_EOF(V1):
> -#line 71 "dtc-lexer.l"
> +#line 73 "dtc-lexer.l"
>  {
>  			if (!pop_input_file()) {
>  				yyterminate();
> @@ -946,23 +898,18 @@ case YY_STATE_EOF(V1):
>  case 2:
>  /* rule 2 can match eol */
>  YY_RULE_SETUP
> -#line 77 "dtc-lexer.l"
> +#line 79 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("String: %s\n", yytext);
>  			yylval.data = data_copy_escape_string(yytext+1,
>  					yyleng-2);
> -			yylloc.first_line = yylineno;
>  			return DT_STRING;
>  		}
>  	YY_BREAK
>  case 3:
>  YY_RULE_SETUP
> -#line 87 "dtc-lexer.l"
> +#line 86 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Keyword: /dts-v1/\n");
>  			dts_version = 1;
>  			BEGIN_DEFAULT();
> @@ -971,10 +918,8 @@ YY_RULE_SETUP
>  	YY_BREAK
>  case 4:
>  YY_RULE_SETUP
> -#line 96 "dtc-lexer.l"
> +#line 93 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Keyword: /memreserve/\n");
>  			BEGIN_DEFAULT();
>  			return DT_MEMRESERVE;
> @@ -982,158 +927,100 @@ YY_RULE_SETUP
>  	YY_BREAK
>  case 5:
>  YY_RULE_SETUP
> -#line 104 "dtc-lexer.l"
> +#line 99 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Label: %s\n", yytext);
> -			yylval.labelref = strdup(yytext);
> +			yylval.labelref = xstrdup(yytext);
>  			yylval.labelref[yyleng-1] = '\0';
>  			return DT_LABEL;
>  		}
>  	YY_BREAK
>  case 6:
>  YY_RULE_SETUP
> -#line 113 "dtc-lexer.l"
> -{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			if (*yytext == 'b')
> -				yylval.cbase = 2;
> -			else if (*yytext == 'o')
> -				yylval.cbase = 8;
> -			else if (*yytext == 'd')
> -				yylval.cbase = 10;
> -			else
> -				yylval.cbase = 16;
> -			DPRINT("Base: %d\n", yylval.cbase);
> -			return DT_BASE;
> -		}
> -	YY_BREAK
> -case 7:
> -YY_RULE_SETUP
> -#line 128 "dtc-lexer.l"
> +#line 106 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			yylval.literal = strdup(yytext);
> -			DPRINT("Literal: '%s'\n", yylval.literal);
> -			return DT_LEGACYLITERAL;
> -		}
> -	YY_BREAK
> -case 8:
> -YY_RULE_SETUP
> -#line 136 "dtc-lexer.l"
> -{
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			yylval.literal = strdup(yytext);
> +			yylval.literal = xstrdup(yytext);
>  			DPRINT("Literal: '%s'\n", yylval.literal);
>  			return DT_LITERAL;
>  		}
>  	YY_BREAK
> -case 9:
> +case 7:
>  YY_RULE_SETUP
> -#line 144 "dtc-lexer.l"
> +#line 112 "dtc-lexer.l"
>  {	/* label reference */
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Ref: %s\n", yytext+1);
> -			yylval.labelref = strdup(yytext+1);
> +			yylval.labelref = xstrdup(yytext+1);
>  			return DT_REF;
>  		}
>  	YY_BREAK
> -case 10:
> +case 8:
>  YY_RULE_SETUP
> -#line 152 "dtc-lexer.l"
> +#line 118 "dtc-lexer.l"
>  {	/* new-style path reference */
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			yytext[yyleng-1] = '\0';
>  			DPRINT("Ref: %s\n", yytext+2);
> -			yylval.labelref = strdup(yytext+2);
> +			yylval.labelref = xstrdup(yytext+2);
>  			return DT_REF;
>  		}
>  	YY_BREAK
> -case 11:
> -YY_RULE_SETUP
> -#line 161 "dtc-lexer.l"
> -{	/* old-style path reference */
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
> -			DPRINT("Ref: %s\n", yytext+1);
> -			yylval.labelref = strdup(yytext+1);
> -			return DT_REF;
> -		}
> -	YY_BREAK
> -case 12:
> +case 9:
>  YY_RULE_SETUP
> -#line 169 "dtc-lexer.l"
> +#line 125 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			yylval.byte = strtol(yytext, NULL, 16);
>  			DPRINT("Byte: %02x\n", (int)yylval.byte);
>  			return DT_BYTE;
>  		}
>  	YY_BREAK
> -case 13:
> +case 10:
>  YY_RULE_SETUP
> -#line 177 "dtc-lexer.l"
> +#line 131 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("/BYTESTRING\n");
>  			BEGIN_DEFAULT();
>  			return ']';
>  		}
>  	YY_BREAK
> -case 14:
> +case 11:
>  YY_RULE_SETUP
> -#line 185 "dtc-lexer.l"
> +#line 137 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("PropNodeName: %s\n", yytext);
> -			yylval.propnodename = strdup(yytext);
> +			yylval.propnodename = xstrdup(yytext);
>  			BEGIN_DEFAULT();
>  			return DT_PROPNODENAME;
>  		}
>  	YY_BREAK
> -case 15:
> +case 12:
>  YY_RULE_SETUP
> -#line 194 "dtc-lexer.l"
> +#line 144 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Binary Include\n");
>  			return DT_INCBIN;
>  		}
>  	YY_BREAK
> -case 16:
> -/* rule 16 can match eol */
> +case 13:
> +/* rule 13 can match eol */
>  YY_RULE_SETUP
> -#line 201 "dtc-lexer.l"
> +#line 149 "dtc-lexer.l"
>  /* eat whitespace */
>  	YY_BREAK
> -case 17:
> -/* rule 17 can match eol */
> +case 14:
> +/* rule 14 can match eol */
>  YY_RULE_SETUP
> -#line 202 "dtc-lexer.l"
> +#line 150 "dtc-lexer.l"
>  /* eat C-style comments */
>  	YY_BREAK
> -case 18:
> -/* rule 18 can match eol */
> +case 15:
> +/* rule 15 can match eol */
>  YY_RULE_SETUP
> -#line 203 "dtc-lexer.l"
> +#line 151 "dtc-lexer.l"
>  /* eat C++-style comments */
>  	YY_BREAK
> -case 19:
> +case 16:
>  YY_RULE_SETUP
> -#line 205 "dtc-lexer.l"
> +#line 153 "dtc-lexer.l"
>  {
> -			yylloc.file = srcpos_file;
> -			yylloc.first_line = yylineno;
>  			DPRINT("Char: %c (\\x%02x)\n", yytext[0],
>  				(unsigned)yytext[0]);
>  			if (yytext[0] == '[') {
> @@ -1148,12 +1035,12 @@ YY_RULE_SETUP
>  			return yytext[0];
>  		}
>  	YY_BREAK
> -case 20:
> +case 17:
>  YY_RULE_SETUP
> -#line 222 "dtc-lexer.l"
> +#line 168 "dtc-lexer.l"
>  ECHO;
>  	YY_BREAK
> -#line 1157 "dtc-lexer.lex.c"
> +#line 1044 "dtc-lexer.lex.c"
>  
>  	case YY_END_OF_BUFFER:
>  		{
> @@ -1218,7 +1105,8 @@ ECHO;
>  
>  			else
>  				{
> -				yy_cp = (yy_c_buf_p);
> +				yy_cp = (yy_last_accepting_cpos);
> +				yy_current_state = (yy_last_accepting_state);
>  				goto yy_find_action;
>  				}
>  			}
> @@ -1443,7 +1331,7 @@ static int yy_get_next_buffer (void)
>  		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
>  			{
>  			yy_current_state = (int) yy_def[yy_current_state];
> -			if ( yy_current_state >= 104 )
> +			if ( yy_current_state >= 94 )
>  				yy_c = yy_meta[(unsigned int) yy_c];
>  			}
>  		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
> @@ -1471,11 +1359,11 @@ static int yy_get_next_buffer (void)
>  	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
>  		{
>  		yy_current_state = (int) yy_def[yy_current_state];
> -		if ( yy_current_state >= 104 )
> +		if ( yy_current_state >= 94 )
>  			yy_c = yy_meta[(unsigned int) yy_c];
>  		}
>  	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
> -	yy_is_jam = (yy_current_state == 103);
> +	yy_is_jam = (yy_current_state == 93);
>  
>  	return yy_is_jam ? 0 : yy_current_state;
>  }
> @@ -1550,11 +1438,6 @@ static int yy_get_next_buffer (void)
>  	*(yy_c_buf_p) = '\0';	/* preserve yytext */
>  	(yy_hold_char) = *++(yy_c_buf_p);
>  
> -	if ( c == '\n' )
> -		   
> -    yylineno++;
> -;
> -
>  	return c;
>  }
>  #endif	/* ifndef YY_NO_INPUT */
> @@ -1669,10 +1552,6 @@ static void yy_load_buffer_state  (void)
>  	yyfree((void *) b  );
>  }
>  
> -#ifndef __cplusplus
> -extern int isatty (int );
> -#endif /* __cplusplus */
> -    
>  /* Initializes or reinitializes a buffer.
>   * This function is sometimes called more than once on the same buffer,
>   * such as during a yyrestart() or at EOF.
> @@ -1696,7 +1575,7 @@ extern int isatty (int );
>          b->yy_bs_column = 0;
>      }
>  
> -        b->yy_is_interactive = file ? (isatty( fileno(file) ) > 0) : 0;
> +        b->yy_is_interactive = 0;
>      
>  	errno = oerrno;
>  }
> @@ -2025,9 +1904,6 @@ static int yy_init_globals (void)
>       * This function is called from yylex_destroy(), so don't allocate here.
>       */
>  
> -    /* We do not touch yylineno unless the option is enabled. */
> -    yylineno =  1;
> -    
>      (yy_buffer_stack) = 0;
>      (yy_buffer_stack_top) = 0;
>      (yy_buffer_stack_max) = 0;
> @@ -2120,104 +1996,29 @@ void yyfree (void * ptr )
>  
>  #define YYTABLES_NAME "yytables"
>  
> -#line 222 "dtc-lexer.l"
> -
> -
> -
> -
> -/*
> - * Stack of nested include file contexts.
> - */
> -
> -struct incl_file {
> -	struct dtc_file *file;
> -	YY_BUFFER_STATE yy_prev_buf;
> -	int yy_prev_lineno;
> -	struct incl_file *prev;
> -};
> -
> -static struct incl_file *incl_file_stack;
> +#line 168 "dtc-lexer.l"
>  
>  
> -/*
> - * Detect infinite include recursion.
> - */
> -#define MAX_INCLUDE_DEPTH	(100)
> -
> -static int incl_depth = 0;
> -
>  
>  static void push_input_file(const char *filename)
>  {
> -	struct incl_file *incl_file;
> -	struct dtc_file *newfile;
> -	struct search_path search, *searchptr = NULL;
> -
>  	assert(filename);
>  
> -	if (incl_depth++ >= MAX_INCLUDE_DEPTH)
> -		die("Includes nested too deeply");
> -
> -	if (srcpos_file) {
> -		search.dir = srcpos_file->dir;
> -		search.next = NULL;
> -		search.prev = NULL;
> -		searchptr = &search;
> -	}
> -
> -	newfile = dtc_open_file(filename, searchptr);
> +	srcfile_push(filename);
>  
> -	incl_file = xmalloc(sizeof(struct incl_file));
> +	yyin = current_srcfile->f;
>  
> -	/*
> -	 * Save current context.
> -	 */
> -	incl_file->yy_prev_buf = YY_CURRENT_BUFFER;
> -	incl_file->yy_prev_lineno = yylineno;
> -	incl_file->file = srcpos_file;
> -	incl_file->prev = incl_file_stack;
> -
> -	incl_file_stack = incl_file;
> -
> -	/*
> -	 * Establish new context.
> -	 */
> -	srcpos_file = newfile;
> -	yylineno = 1;
> -	yyin = newfile->file;
> -	yy_switch_to_buffer(yy_create_buffer(yyin,YY_BUF_SIZE));
> +	yypush_buffer_state(yy_create_buffer(yyin,YY_BUF_SIZE));
>  }
>  
>  
>  static int pop_input_file(void)
>  {
> -	struct incl_file *incl_file;
> -
> -	if (incl_file_stack == 0)
> +	if (srcfile_pop() == 0)
>  		return 0;
>  
> -	dtc_close_file(srcpos_file);
> -
> -	/*
> -	 * Pop.
> -	 */
> -	--incl_depth;
> -	incl_file = incl_file_stack;
> -	incl_file_stack = incl_file->prev;
> -
> -	/*
> -	 * Recover old context.
> -	 */
> -	yy_delete_buffer(YY_CURRENT_BUFFER);
> -	yy_switch_to_buffer(incl_file->yy_prev_buf);
> -	yylineno = incl_file->yy_prev_lineno;
> -	srcpos_file = incl_file->file;
> -	yyin = incl_file->file ? incl_file->file->file : NULL;
> -
> -	/*
> -	 * Free old state.
> -	 */
> -	free(incl_file);
> +	yypop_buffer_state();
> +	yyin = current_srcfile->f;
>  
>  	return 1;
>  }
> diff --git a/scripts/dtc/dtc-parser.tab.c_shipped b/scripts/dtc/dtc-parser.tab.c_shipped
> index 2712937..9be2eea 100644
> --- a/scripts/dtc/dtc-parser.tab.c_shipped
> +++ b/scripts/dtc/dtc-parser.tab.c_shipped
> @@ -1,24 +1,23 @@
> -/* A Bison parser, made by GNU Bison 2.3.  */
>  
> -/* Skeleton implementation for Bison's Yacc-like parsers in C
> +/* A Bison parser, made by GNU Bison 2.4.1.  */
>  
> -   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
> +/* Skeleton implementation for Bison's Yacc-like parsers in C
> +   
> +      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
>     Free Software Foundation, Inc.
> -
> -   This program is free software; you can redistribute it and/or modify
> +   
> +   This program is free software: you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
> -   the Free Software Foundation; either version 2, or (at your option)
> -   any later version.
> -
> +   the Free Software Foundation, either version 3 of the License, or
> +   (at your option) any later version.
> +   
>     This program is distributed in the hope that it will be useful,
>     but WITHOUT ANY WARRANTY; without even the implied warranty of
>     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>     GNU General Public License for more details.
> -
> +   
>     You should have received a copy of the GNU General Public License
> -   along with this program; if not, write to the Free Software
> -   Foundation, Inc., 51 Franklin Street, Fifth Floor,
> -   Boston, MA 02110-1301, USA.  */
> +   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
>  
>  /* As a special exception, you may create a larger work that contains
>     part or all of the Bison parser skeleton and distribute that work
> @@ -29,7 +28,7 @@
>     special exception, which will cause the skeleton and the resulting
>     Bison output files to be licensed under the GNU General Public
>     License without this special exception.
> -
> +   
>     This special exception was added by the Free Software Foundation in
>     version 2.2 of Bison.  */
>  
> @@ -47,7 +46,7 @@
>  #define YYBISON 1
>  
>  /* Bison version.  */
> -#define YYBISON_VERSION "2.3"
> +#define YYBISON_VERSION "2.4.1"
>  
>  /* Skeleton name.  */
>  #define YYSKELETON_NAME "yacc.c"
> @@ -55,55 +54,32 @@
>  /* Pure parsers.  */
>  #define YYPURE 0
>  
> -/* Using locations.  */
> -#define YYLSP_NEEDED 1
> -
> +/* Push parsers.  */
> +#define YYPUSH 0
>  
> +/* Pull parsers.  */
> +#define YYPULL 1
>  
> -/* Tokens.  */
> -#ifndef YYTOKENTYPE
> -# define YYTOKENTYPE
> -   /* Put the tokens into the symbol table, so that GDB and other debuggers
> -      know about them.  */
> -   enum yytokentype {
> -     DT_V1 = 258,
> -     DT_MEMRESERVE = 259,
> -     DT_PROPNODENAME = 260,
> -     DT_LITERAL = 261,
> -     DT_LEGACYLITERAL = 262,
> -     DT_BASE = 263,
> -     DT_BYTE = 264,
> -     DT_STRING = 265,
> -     DT_LABEL = 266,
> -     DT_REF = 267,
> -     DT_INCBIN = 268
> -   };
> -#endif
> -/* Tokens.  */
> -#define DT_V1 258
> -#define DT_MEMRESERVE 259
> -#define DT_PROPNODENAME 260
> -#define DT_LITERAL 261
> -#define DT_LEGACYLITERAL 262
> -#define DT_BASE 263
> -#define DT_BYTE 264
> -#define DT_STRING 265
> -#define DT_LABEL 266
> -#define DT_REF 267
> -#define DT_INCBIN 268
> -
> +/* Using locations.  */
> +#define YYLSP_NEEDED 0
>  
>  
>  
>  /* Copy the first part of user declarations.  */
> -#line 23 "dtc-parser.y"
> +
> +/* Line 189 of yacc.c  */
> +#line 21 "dtc-parser.y"
>  
>  #include <stdio.h>
>  
>  #include "dtc.h"
>  #include "srcpos.h"
>  
> +YYLTYPE yylloc;
> +
>  extern int yylex(void);
> +extern void print_error(char const *fmt, ...);
> +extern void yyerror(char const *s);
>  
>  extern struct boot_info *the_boot_info;
>  extern int treesource_error;
> @@ -111,6 +87,9 @@ extern int treesource_error;
>  static unsigned long long eval_literal(const char *s, int base, int bits);
>  
>  
> +/* Line 189 of yacc.c  */
> +#line 92 "dtc-parser.tab.c"
> +
>  /* Enabling traces.  */
>  #ifndef YYDEBUG
>  # define YYDEBUG 0
> @@ -129,10 +108,35 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
>  # define YYTOKEN_TABLE 0
>  #endif
>  
> +
> +/* Tokens.  */
> +#ifndef YYTOKENTYPE
> +# define YYTOKENTYPE
> +   /* Put the tokens into the symbol table, so that GDB and other debuggers
> +      know about them.  */
> +   enum yytokentype {
> +     DT_V1 = 258,
> +     DT_MEMRESERVE = 259,
> +     DT_PROPNODENAME = 260,
> +     DT_LITERAL = 261,
> +     DT_BASE = 262,
> +     DT_BYTE = 263,
> +     DT_STRING = 264,
> +     DT_LABEL = 265,
> +     DT_REF = 266,
> +     DT_INCBIN = 267
> +   };
> +#endif
> +
> +
> +
>  #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
>  typedef union YYSTYPE
> -#line 37 "dtc-parser.y"
>  {
> +
> +/* Line 214 of yacc.c  */
> +#line 39 "dtc-parser.y"
> +
>  	char *propnodename;
>  	char *literal;
>  	char *labelref;
> @@ -147,34 +151,23 @@ typedef union YYSTYPE
>  	struct node *node;
>  	struct node *nodelist;
>  	struct reserve_info *re;
> -}
> -/* Line 187 of yacc.c.  */
> -#line 153 "dtc-parser.tab.c"
> -	YYSTYPE;
> +
> +
> +
> +/* Line 214 of yacc.c  */
> +#line 159 "dtc-parser.tab.c"
> +} YYSTYPE;
> +# define YYSTYPE_IS_TRIVIAL 1
>  # define yystype YYSTYPE /* obsolescent; will be withdrawn */
>  # define YYSTYPE_IS_DECLARED 1
> -# define YYSTYPE_IS_TRIVIAL 1
> -#endif
> -
> -#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
> -typedef struct YYLTYPE
> -{
> -  int first_line;
> -  int first_column;
> -  int last_line;
> -  int last_column;
> -} YYLTYPE;
> -# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
> -# define YYLTYPE_IS_DECLARED 1
> -# define YYLTYPE_IS_TRIVIAL 1
>  #endif
>  
>  
>  /* Copy the second part of user declarations.  */
>  
>  
> -/* Line 216 of yacc.c.  */
> -#line 178 "dtc-parser.tab.c"
> +/* Line 264 of yacc.c  */
> +#line 171 "dtc-parser.tab.c"
>  
>  #ifdef short
>  # undef short
> @@ -249,14 +242,14 @@ typedef short int yytype_int16;
>  #if (defined __STDC__ || defined __C99__FUNC__ \
>       || defined __cplusplus || defined _MSC_VER)
>  static int
> -YYID (int i)
> +YYID (int yyi)
>  #else
>  static int
> -YYID (i)
> -    int i;
> +YYID (yyi)
> +    int yyi;
>  #endif
>  {
> -  return i;
> +  return yyi;
>  }
>  #endif
>  
> @@ -332,15 +325,13 @@ void free (void *); /* INFRINGES ON USER NAME SPACE */
>  
>  #if (! defined yyoverflow \
>       && (! defined __cplusplus \
> -	 || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
> -	     && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
> +	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
>  
>  /* A type that is properly aligned for any stack member.  */
>  union yyalloc
>  {
> -  yytype_int16 yyss;
> -  YYSTYPE yyvs;
> -    YYLTYPE yyls;
> +  yytype_int16 yyss_alloc;
> +  YYSTYPE yyvs_alloc;
>  };
>  
>  /* The size of the maximum gap between one aligned stack and the next.  */
> @@ -349,8 +340,8 @@ union yyalloc
>  /* The size of an array large to enough to hold all stacks, each with
>     N elements.  */
>  # define YYSTACK_BYTES(N) \
> -     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
> -      + 2 * YYSTACK_GAP_MAXIMUM)
> +     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
> +      + YYSTACK_GAP_MAXIMUM)
>  
>  /* Copy COUNT objects from FROM to TO.  The source and destination do
>     not overlap.  */
> @@ -375,12 +366,12 @@ union yyalloc
>     elements in the stack, and YYPTR gives the new location of the
>     stack.  Advance YYPTR to a properly aligned location for the next
>     stack.  */
> -# define YYSTACK_RELOCATE(Stack)					\
> +# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
>      do									\
>        {									\
>  	YYSIZE_T yynewbytes;						\
> -	YYCOPY (&yyptr->Stack, Stack, yysize);				\
> -	Stack = &yyptr->Stack;						\
> +	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
> +	Stack = &yyptr->Stack_alloc;					\
>  	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
>  	yyptr += yynewbytes / sizeof (*yyptr);				\
>        }									\
> @@ -389,22 +380,22 @@ union yyalloc
>  #endif
>  
>  /* YYFINAL -- State number of the termination state.  */
> -#define YYFINAL  9
> +#define YYFINAL  4
>  /* YYLAST -- Last index in YYTABLE.  */
> -#define YYLAST   73
> +#define YYLAST   56
>  
>  /* YYNTOKENS -- Number of terminals.  */
> -#define YYNTOKENS  27
> +#define YYNTOKENS  25
>  /* YYNNTS -- Number of nonterminals.  */
> -#define YYNNTS  20
> +#define YYNNTS  16
>  /* YYNRULES -- Number of rules.  */
> -#define YYNRULES  45
> +#define YYNRULES  39
>  /* YYNRULES -- Number of states.  */
> -#define YYNSTATES  76
> +#define YYNSTATES  67
>  
>  /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
>  #define YYUNDEFTOK  2
> -#define YYMAXUTOK   268
> +#define YYMAXUTOK   267
>  
>  #define YYTRANSLATE(YYX)						\
>    ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
> @@ -416,15 +407,15 @@ static const yytype_uint8 yytranslate[] =
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
> -      24,    26,     2,     2,    25,    15,     2,    16,     2,     2,
> -       2,     2,     2,     2,     2,     2,     2,     2,     2,    14,
> -      20,    19,    21,     2,     2,     2,     2,     2,     2,     2,
> +      22,    24,     2,     2,    23,     2,     2,    14,     2,     2,
> +       2,     2,     2,     2,     2,     2,     2,     2,     2,    13,
> +      18,    17,    19,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
> -       2,    22,     2,    23,     2,     2,     2,     2,     2,     2,
> +       2,    20,     2,    21,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
> -       2,     2,     2,    17,     2,    18,     2,     2,     2,     2,
> +       2,     2,     2,    15,     2,    16,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
> @@ -438,7 +429,7 @@ static const yytype_uint8 yytranslate[] =
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
>         2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
> -       5,     6,     7,     8,     9,    10,    11,    12,    13
> +       5,     6,     7,     8,     9,    10,    11,    12
>  };
>  
>  #if YYDEBUG
> @@ -446,41 +437,37 @@ static const yytype_uint8 yytranslate[] =
>     YYRHS.  */
>  static const yytype_uint8 yyprhs[] =
>  {
> -       0,     0,     3,     8,    11,    12,    15,    21,    22,    25,
> -      27,    34,    36,    38,    41,    47,    48,    51,    57,    61,
> -      64,    69,    74,    77,    87,    93,    96,    97,   100,   103,
> -     104,   107,   110,   113,   114,   116,   118,   121,   122,   125,
> -     128,   129,   132,   135,   139,   140
> +       0,     0,     3,     8,     9,    12,    17,    20,    22,    25,
> +      29,    33,    39,    40,    43,    48,    51,    54,    57,    62,
> +      67,    70,    80,    86,    89,    90,    93,    96,    97,   100,
> +     103,   106,   108,   109,   112,   115,   116,   119,   122,   125
>  };
>  
>  /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
>  static const yytype_int8 yyrhs[] =
>  {
> -      28,     0,    -1,     3,    14,    29,    34,    -1,    31,    34,
> -      -1,    -1,    30,    29,    -1,    46,     4,    33,    33,    14,
> -      -1,    -1,    32,    31,    -1,    30,    -1,    46,     4,    33,
> -      15,    33,    14,    -1,     6,    -1,     7,    -1,    16,    35,
> -      -1,    17,    36,    44,    18,    14,    -1,    -1,    36,    37,
> -      -1,    46,     5,    19,    38,    14,    -1,    46,     5,    14,
> -      -1,    39,    10,    -1,    39,    20,    40,    21,    -1,    39,
> -      22,    43,    23,    -1,    39,    12,    -1,    39,    13,    24,
> -      10,    25,    33,    25,    33,    26,    -1,    39,    13,    24,
> -      10,    26,    -1,    38,    11,    -1,    -1,    38,    25,    -1,
> -      39,    11,    -1,    -1,    40,    42,    -1,    40,    12,    -1,
> -      40,    11,    -1,    -1,     8,    -1,     6,    -1,    41,     7,
> -      -1,    -1,    43,     9,    -1,    43,    11,    -1,    -1,    45,
> -      44,    -1,    45,    37,    -1,    46,     5,    35,    -1,    -1,
> -      11,    -1
> +      26,     0,    -1,     3,    13,    27,    30,    -1,    -1,    28,
> +      27,    -1,     4,    29,    29,    13,    -1,    10,    28,    -1,
> +       6,    -1,    14,    31,    -1,    30,    14,    31,    -1,    30,
> +      11,    31,    -1,    15,    32,    39,    16,    13,    -1,    -1,
> +      32,    33,    -1,     5,    17,    34,    13,    -1,     5,    13,
> +      -1,    10,    33,    -1,    35,     9,    -1,    35,    18,    36,
> +      19,    -1,    35,    20,    38,    21,    -1,    35,    11,    -1,
> +      35,    12,    22,     9,    23,    29,    23,    29,    24,    -1,
> +      35,    12,    22,     9,    24,    -1,    34,    10,    -1,    -1,
> +      34,    23,    -1,    35,    10,    -1,    -1,    36,    37,    -1,
> +      36,    11,    -1,    36,    10,    -1,     6,    -1,    -1,    38,
> +       8,    -1,    38,    10,    -1,    -1,    40,    39,    -1,    40,
> +      33,    -1,     5,    31,    -1,    10,    40,    -1
>  };
>  
>  /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
>  static const yytype_uint16 yyrline[] =
>  {
> -       0,    89,    89,    93,   101,   104,   111,   119,   122,   129,
> -     133,   140,   144,   151,   158,   166,   169,   176,   180,   187,
> -     191,   195,   199,   203,   220,   231,   239,   242,   246,   254,
> -     257,   261,   266,   274,   277,   281,   285,   293,   296,   300,
> -     308,   311,   315,   323,   331,   334
> +       0,    86,    86,    95,    98,   105,   109,   117,   124,   128,
> +     132,   145,   153,   156,   163,   167,   171,   179,   183,   187,
> +     191,   195,   212,   222,   230,   233,   237,   245,   248,   252,
> +     257,   264,   272,   275,   279,   287,   290,   294,   302,   306
>  };
>  #endif
>  
> @@ -490,13 +477,12 @@ static const yytype_uint16 yyrline[] =
>  static const char *const yytname[] =
>  {
>    "$end", "error", "$undefined", "DT_V1", "DT_MEMRESERVE",
> -  "DT_PROPNODENAME", "DT_LITERAL", "DT_LEGACYLITERAL", "DT_BASE",
> -  "DT_BYTE", "DT_STRING", "DT_LABEL", "DT_REF", "DT_INCBIN", "';'", "'-'",
> -  "'/'", "'{'", "'}'", "'='", "'<'", "'>'", "'['", "']'", "'('", "','",
> -  "')'", "$accept", "sourcefile", "memreserves", "memreserve",
> -  "v0_memreserves", "v0_memreserve", "addr", "devicetree", "nodedef",
> -  "proplist", "propdef", "propdata", "propdataprefix", "celllist",
> -  "cellbase", "cellval", "bytestring", "subnodes", "subnode", "label", 0
> +  "DT_PROPNODENAME", "DT_LITERAL", "DT_BASE", "DT_BYTE", "DT_STRING",
> +  "DT_LABEL", "DT_REF", "DT_INCBIN", "';'", "'/'", "'{'", "'}'", "'='",
> +  "'<'", "'>'", "'['", "']'", "'('", "','", "')'", "$accept", "sourcefile",
> +  "memreserves", "memreserve", "addr", "devicetree", "nodedef", "proplist",
> +  "propdef", "propdata", "propdataprefix", "celllist", "cellval",
> +  "bytestring", "subnodes", "subnode", 0
>  };
>  #endif
>  
> @@ -506,29 +492,27 @@ static const char *const yytname[] =
>  static const yytype_uint16 yytoknum[] =
>  {
>         0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
> -     265,   266,   267,   268,    59,    45,    47,   123,   125,    61,
> -      60,    62,    91,    93,    40,    44,    41
> +     265,   266,   267,    59,    47,   123,   125,    61,    60,    62,
> +      91,    93,    40,    44,    41
>  };
>  # endif
>  
>  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
>  static const yytype_uint8 yyr1[] =
>  {
> -       0,    27,    28,    28,    29,    29,    30,    31,    31,    32,
> -      32,    33,    33,    34,    35,    36,    36,    37,    37,    38,
> -      38,    38,    38,    38,    38,    38,    39,    39,    39,    40,
> -      40,    40,    40,    41,    41,    42,    42,    43,    43,    43,
> -      44,    44,    44,    45,    46,    46
> +       0,    25,    26,    27,    27,    28,    28,    29,    30,    30,
> +      30,    31,    32,    32,    33,    33,    33,    34,    34,    34,
> +      34,    34,    34,    34,    35,    35,    35,    36,    36,    36,
> +      36,    37,    38,    38,    38,    39,    39,    39,    40,    40
>  };
>  
>  /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
>  static const yytype_uint8 yyr2[] =
>  {
> -       0,     2,     4,     2,     0,     2,     5,     0,     2,     1,
> -       6,     1,     1,     2,     5,     0,     2,     5,     3,     2,
> -       4,     4,     2,     9,     5,     2,     0,     2,     2,     0,
> -       2,     2,     2,     0,     1,     1,     2,     0,     2,     2,
> -       0,     2,     2,     3,     0,     1
> +       0,     2,     4,     0,     2,     4,     2,     1,     2,     3,
> +       3,     5,     0,     2,     4,     2,     2,     2,     4,     4,
> +       2,     9,     5,     2,     0,     2,     2,     0,     2,     2,
> +       2,     1,     0,     2,     2,     0,     2,     2,     2,     2
>  };
>  
>  /* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
> @@ -536,86 +520,79 @@ static const yytype_uint8 yyr2[] =
>     means the default is an error.  */
>  static const yytype_uint8 yydefact[] =
>  {
> -       7,     0,    45,     0,     9,     0,     7,     0,     4,     1,
> -       0,     3,     8,     0,     0,     4,     0,    15,    13,    11,
> -      12,     0,     2,     5,     0,    40,     0,     0,     0,    16,
> -       0,    40,     0,     0,     6,     0,    42,    41,     0,    10,
> -      14,    18,    26,    43,     0,     0,    25,    17,    27,    19,
> -      28,    22,     0,    29,    37,     0,    33,     0,     0,    35,
> -      34,    32,    31,    20,     0,    30,    38,    39,    21,     0,
> -      24,    36,     0,     0,     0,    23
> +       0,     0,     0,     3,     1,     0,     0,     0,     3,     7,
> +       0,     6,     0,     2,     4,     0,    12,     8,     0,     0,
> +       5,    35,    10,     9,     0,     0,    13,     0,    35,    15,
> +      24,    38,    16,    39,     0,    37,    36,     0,     0,    11,
> +      23,    14,    25,    17,    26,    20,     0,    27,    32,     0,
> +       0,     0,     0,    31,    30,    29,    18,    28,    33,    34,
> +      19,     0,    22,     0,     0,     0,    21
>  };
>  
>  /* YYDEFGOTO[NTERM-NUM].  */
>  static const yytype_int8 yydefgoto[] =
>  {
> -      -1,     3,    14,     4,     5,     6,    27,    11,    18,    25,
> -      29,    44,    45,    56,    64,    65,    57,    30,    31,     7
> +      -1,     2,     7,     8,    10,    13,    17,    21,    26,    37,
> +      38,    50,    57,    51,    27,    28
>  };
>  
>  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
>     STATE-NUM.  */
> -#define YYPACT_NINF -14
> +#define YYPACT_NINF -12
>  static const yytype_int8 yypact[] =
>  {
> -      30,   -11,   -14,     7,   -14,    -1,    27,    13,    27,   -14,
> -       8,   -14,   -14,    40,    -1,    27,    35,   -14,   -14,   -14,
> -     -14,    21,   -14,   -14,    40,    24,    40,    28,    40,   -14,
> -      32,    24,    46,    38,   -14,    39,   -14,   -14,    26,   -14,
> -     -14,   -14,   -14,   -14,    -9,    10,   -14,   -14,   -14,   -14,
> -     -14,   -14,    31,   -14,   -14,    44,    -2,     3,    23,   -14,
> -     -14,   -14,   -14,   -14,    50,   -14,   -14,   -14,   -14,    40,
> -     -14,   -14,    33,    40,    36,   -14
> +      10,   -11,    18,    -1,   -12,    22,    -1,    15,    -1,   -12,
> +      22,   -12,    20,     1,   -12,    17,   -12,   -12,    20,    20,
> +     -12,     6,   -12,   -12,    21,     6,   -12,    23,     6,   -12,
> +     -12,   -12,   -12,   -12,    28,   -12,   -12,    -6,    13,   -12,
> +     -12,   -12,   -12,   -12,   -12,   -12,    24,   -12,   -12,    33,
> +      -5,     0,    -4,   -12,   -12,   -12,   -12,   -12,   -12,   -12,
> +     -12,    22,   -12,    25,    22,    19,   -12
>  };
>  
>  /* YYPGOTO[NTERM-NUM].  */
>  static const yytype_int8 yypgoto[] =
>  {
> -     -14,   -14,    48,    29,    53,   -14,   -13,    47,    34,   -14,
> -      37,   -14,   -14,   -14,   -14,   -14,   -14,    42,   -14,    -7
> +     -12,   -12,    36,    39,   -10,   -12,     8,   -12,    12,   -12,
> +     -12,   -12,   -12,   -12,    27,    31
>  };
>  
>  /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
>     positive, shift that token.  If negative, reduce the rule which
>     number is the opposite.  If zero, do what YYDEFACT says.
>     If YYTABLE_NINF, syntax error.  */
> -#define YYTABLE_NINF -45
> -static const yytype_int8 yytable[] =
> +#define YYTABLE_NINF -1
> +static const yytype_uint8 yytable[] =
>  {
> -      21,    16,    46,     8,    59,    47,    60,     9,    16,    61,
> -      62,    28,    66,    33,    67,    10,    48,    13,    32,    63,
> -      49,    50,    51,    52,    32,    17,    68,    19,    20,   -44,
> -      53,   -44,    54,     1,   -44,     2,    26,    15,     2,    24,
> -      41,     2,    34,    17,    15,    42,    19,    20,    69,    70,
> -      35,    38,    39,    40,    58,    55,    72,    71,    73,    12,
> -      74,    22,    75,    23,     0,     0,     0,     0,    36,     0,
> -       0,     0,    43,    37
> +      15,    53,     3,     5,    40,    54,    55,    41,    58,     6,
> +      59,    24,    18,     1,    56,    19,    25,    42,     4,    61,
> +      62,    60,    43,    44,    45,    46,    22,    23,     9,    12,
> +      20,    47,    31,    48,    29,    16,    16,    32,    30,    34,
> +      35,    39,    52,    66,    14,    11,    49,     0,    64,     0,
> +       0,    63,     0,     0,    65,    36,    33
>  };
>  
>  static const yytype_int8 yycheck[] =
>  {
> -      13,     8,    11,    14,     6,    14,     8,     0,    15,    11,
> -      12,    24,     9,    26,    11,    16,    25,     4,    25,    21,
> -      10,    11,    12,    13,    31,    17,    23,     6,     7,     5,
> -      20,     4,    22,     3,     4,    11,    15,     8,    11,     4,
> -      14,    11,    14,    17,    15,    19,     6,     7,    25,    26,
> -      18,     5,    14,    14,    10,    24,    69,     7,    25,     6,
> -      73,    14,    26,    15,    -1,    -1,    -1,    -1,    31,    -1,
> -      -1,    -1,    38,    31
> +      10,     6,    13,     4,    10,    10,    11,    13,     8,    10,
> +      10,     5,    11,     3,    19,    14,    10,    23,     0,    23,
> +      24,    21,     9,    10,    11,    12,    18,    19,     6,    14,
> +      13,    18,    24,    20,    13,    15,    15,    25,    17,    16,
> +      28,    13,     9,    24,     8,     6,    22,    -1,    23,    -1,
> +      -1,    61,    -1,    -1,    64,    28,    25
>  };
>  
>  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
>     symbol of state STATE-NUM.  */
>  static const yytype_uint8 yystos[] =
>  {
> -       0,     3,    11,    28,    30,    31,    32,    46,    14,     0,
> -      16,    34,    31,     4,    29,    30,    46,    17,    35,     6,
> -       7,    33,    34,    29,     4,    36,    15,    33,    33,    37,
> -      44,    45,    46,    33,    14,    18,    37,    44,     5,    14,
> -      14,    14,    19,    35,    38,    39,    11,    14,    25,    10,
> -      11,    12,    13,    20,    22,    24,    40,    43,    10,     6,
> -       8,    11,    12,    21,    41,    42,     9,    11,    23,    25,
> -      26,     7,    33,    25,    33,    26
> +       0,     3,    26,    13,     0,     4,    10,    27,    28,     6,
> +      29,    28,    14,    30,    27,    29,    15,    31,    11,    14,
> +      13,    32,    31,    31,     5,    10,    33,    39,    40,    13,
> +      17,    31,    33,    40,    16,    33,    39,    34,    35,    13,
> +      10,    13,    23,     9,    10,    11,    12,    18,    20,    22,
> +      36,    38,     9,     6,    10,    11,    19,    37,     8,    10,
> +      21,    23,    24,    29,    23,    29,    24
>  };
>  
>  #define yyerrok		(yyerrstatus = 0)
> @@ -728,7 +705,7 @@ do {									  \
>      {									  \
>        YYFPRINTF (stderr, "%s ", Title);					  \
>        yy_symbol_print (stderr,						  \
> -		  Type, Value, Location); \
> +		  Type, Value); \
>        YYFPRINTF (stderr, "\n");						  \
>      }									  \
>  } while (YYID (0))
> @@ -742,19 +719,17 @@ do {									  \
>  #if (defined __STDC__ || defined __C99__FUNC__ \
>       || defined __cplusplus || defined _MSC_VER)
>  static void
> -yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
> +yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
>  #else
>  static void
> -yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
> +yy_symbol_value_print (yyoutput, yytype, yyvaluep)
>      FILE *yyoutput;
>      int yytype;
>      YYSTYPE const * const yyvaluep;
> -    YYLTYPE const * const yylocationp;
>  #endif
>  {
>    if (!yyvaluep)
>      return;
> -  YYUSE (yylocationp);
>  # ifdef YYPRINT
>    if (yytype < YYNTOKENS)
>      YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
> @@ -776,14 +751,13 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
>  #if (defined __STDC__ || defined __C99__FUNC__ \
>       || defined __cplusplus || defined _MSC_VER)
>  static void
> -yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
> +yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
>  #else
>  static void
> -yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
> +yy_symbol_print (yyoutput, yytype, yyvaluep)
>      FILE *yyoutput;
>      int yytype;
>      YYSTYPE const * const yyvaluep;
> -    YYLTYPE const * const yylocationp;
>  #endif
>  {
>    if (yytype < YYNTOKENS)
> @@ -791,9 +765,7 @@ yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
>    else
>      YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);
>  
> -  YY_LOCATION_PRINT (yyoutput, *yylocationp);
> -  YYFPRINTF (yyoutput, ": ");
> -  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
> +  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
>    YYFPRINTF (yyoutput, ")");
>  }
>  
> @@ -805,17 +777,20 @@ yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
>  #if (defined __STDC__ || defined __C99__FUNC__ \
>       || defined __cplusplus || defined _MSC_VER)
>  static void
> -yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
> +yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
>  #else
>  static void
> -yy_stack_print (bottom, top)
> -    yytype_int16 *bottom;
> -    yytype_int16 *top;
> +yy_stack_print (yybottom, yytop)
> +    yytype_int16 *yybottom;
> +    yytype_int16 *yytop;
>  #endif
>  {
>    YYFPRINTF (stderr, "Stack now");
> -  for (; bottom <= top; ++bottom)
> -    YYFPRINTF (stderr, " %d", *bottom);
> +  for (; yybottom <= yytop; yybottom++)
> +    {
> +      int yybot = *yybottom;
> +      YYFPRINTF (stderr, " %d", yybot);
> +    }
>    YYFPRINTF (stderr, "\n");
>  }
>  
> @@ -833,12 +808,11 @@ do {								\
>  #if (defined __STDC__ || defined __C99__FUNC__ \
>       || defined __cplusplus || defined _MSC_VER)
>  static void
> -yy_reduce_print (YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
> +yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
>  #else
>  static void
> -yy_reduce_print (yyvsp, yylsp, yyrule)
> +yy_reduce_print (yyvsp, yyrule)
>      YYSTYPE *yyvsp;
> -    YYLTYPE *yylsp;
>      int yyrule;
>  #endif
>  {
> @@ -850,18 +824,18 @@ yy_reduce_print (yyvsp, yylsp, yyrule)
>    /* The symbols being reduced.  */
>    for (yyi = 0; yyi < yynrhs; yyi++)
>      {
> -      fprintf (stderr, "   $%d = ", yyi + 1);
> +      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
>        yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
>  		       &(yyvsp[(yyi + 1) - (yynrhs)])
> -		       , &(yylsp[(yyi + 1) - (yynrhs)])		       );
> -      fprintf (stderr, "\n");
> +		       		       );
> +      YYFPRINTF (stderr, "\n");
>      }
>  }
>  
>  # define YY_REDUCE_PRINT(Rule)		\
>  do {					\
>    if (yydebug)				\
> -    yy_reduce_print (yyvsp, yylsp, Rule); \
> +    yy_reduce_print (yyvsp, Rule); \
>  } while (YYID (0))
>  
>  /* Nonzero means print parse trace.  It is left uninitialized so that
> @@ -1112,18 +1086,16 @@ yysyntax_error (char *yyresult, int yystate, int yychar)
>  #if (defined __STDC__ || defined __C99__FUNC__ \
>       || defined __cplusplus || defined _MSC_VER)
>  static void
> -yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
> +yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
>  #else
>  static void
> -yydestruct (yymsg, yytype, yyvaluep, yylocationp)
> +yydestruct (yymsg, yytype, yyvaluep)
>      const char *yymsg;
>      int yytype;
>      YYSTYPE *yyvaluep;
> -    YYLTYPE *yylocationp;
>  #endif
>  {
>    YYUSE (yyvaluep);
> -  YYUSE (yylocationp);
>  
>    if (!yymsg)
>      yymsg = "Deleting";
> @@ -1136,10 +1108,8 @@ yydestruct (yymsg, yytype, yyvaluep, yylocationp)
>  	break;
>      }
>  }
> -
>  
>  /* Prevent warnings from -Wmissing-prototypes.  */
> -
>  #ifdef YYPARSE_PARAM
>  #if defined __STDC__ || defined __cplusplus
>  int yyparse (void *YYPARSE_PARAM);
> @@ -1155,23 +1125,20 @@ int yyparse ();
>  #endif /* ! YYPARSE_PARAM */
>  
>  
> -
> -/* The look-ahead symbol.  */
> +/* The lookahead symbol.  */
>  int yychar;
>  
> -/* The semantic value of the look-ahead symbol.  */
> +/* The semantic value of the lookahead symbol.  */
>  YYSTYPE yylval;
>  
>  /* Number of syntax errors so far.  */
>  int yynerrs;
> -/* Location data for the look-ahead symbol.  */
> -YYLTYPE yylloc;
>  
>  
>  
> -/*----------.
> -| yyparse.  |
> -`----------*/
> +/*-------------------------.
> +| yyparse or yypush_parse.  |
> +`-------------------------*/
>  
>  #ifdef YYPARSE_PARAM
>  #if (defined __STDC__ || defined __C99__FUNC__ \
> @@ -1195,79 +1162,70 @@ yyparse ()
>  #endif
>  #endif
>  {
> -  
> -  int yystate;
> -  int yyn;
> -  int yyresult;
> -  /* Number of tokens to shift before error messages enabled.  */
> -  int yyerrstatus;
> -  /* Look-ahead token as an internal (translated) token number.  */
> -  int yytoken = 0;
> -#if YYERROR_VERBOSE
> -  /* Buffer for error messages, and its allocated size.  */
> -  char yymsgbuf[128];
> -  char *yymsg = yymsgbuf;
> -  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
> -#endif
>  
> -  /* Three stacks and their tools:
> -     `yyss': related to states,
> -     `yyvs': related to semantic values,
> -     `yyls': related to locations.
>  
> -     Refer to the stacks thru separate pointers, to allow yyoverflow
> -     to reallocate them elsewhere.  */
> +    int yystate;
> +    /* Number of tokens to shift before error messages enabled.  */
> +    int yyerrstatus;
>  
> -  /* The state stack.  */
> -  yytype_int16 yyssa[YYINITDEPTH];
> -  yytype_int16 *yyss = yyssa;
> -  yytype_int16 *yyssp;
> +    /* The stacks and their tools:
> +       `yyss': related to states.
> +       `yyvs': related to semantic values.
>  
> -  /* The semantic value stack.  */
> -  YYSTYPE yyvsa[YYINITDEPTH];
> -  YYSTYPE *yyvs = yyvsa;
> -  YYSTYPE *yyvsp;
> +       Refer to the stacks thru separate pointers, to allow yyoverflow
> +       to reallocate them elsewhere.  */
>  
> -  /* The location stack.  */
> -  YYLTYPE yylsa[YYINITDEPTH];
> -  YYLTYPE *yyls = yylsa;
> -  YYLTYPE *yylsp;
> -  /* The locations where the error started and ended.  */
> -  YYLTYPE yyerror_range[2];
> +    /* The state stack.  */
> +    yytype_int16 yyssa[YYINITDEPTH];
> +    yytype_int16 *yyss;
> +    yytype_int16 *yyssp;
>  
> -#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))
> +    /* The semantic value stack.  */
> +    YYSTYPE yyvsa[YYINITDEPTH];
> +    YYSTYPE *yyvs;
> +    YYSTYPE *yyvsp;
>  
> -  YYSIZE_T yystacksize = YYINITDEPTH;
> +    YYSIZE_T yystacksize;
>  
> +  int yyn;
> +  int yyresult;
> +  /* Lookahead token as an internal (translated) token number.  */
> +  int yytoken;
>    /* The variables used to return semantic value and location from the
>       action routines.  */
>    YYSTYPE yyval;
> -  YYLTYPE yyloc;
> +
> +#if YYERROR_VERBOSE
> +  /* Buffer for error messages, and its allocated size.  */
> +  char yymsgbuf[128];
> +  char *yymsg = yymsgbuf;
> +  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
> +#endif
> +
> +#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
>  
>    /* The number of symbols on the RHS of the reduced rule.
>       Keep to zero when no symbol should be popped.  */
>    int yylen = 0;
>  
> +  yytoken = 0;
> +  yyss = yyssa;
> +  yyvs = yyvsa;
> +  yystacksize = YYINITDEPTH;
> +
>    YYDPRINTF ((stderr, "Starting parse\n"));
>  
>    yystate = 0;
>    yyerrstatus = 0;
>    yynerrs = 0;
> -  yychar = YYEMPTY;		/* Cause a token to be read.  */
> +  yychar = YYEMPTY; /* Cause a token to be read.  */
>  
>    /* Initialize stack pointers.
>       Waste one element of value and location stack
>       so that they stay on the same level as the state stack.
>       The wasted elements are never initialized.  */
> -
>    yyssp = yyss;
>    yyvsp = yyvs;
> -  yylsp = yyls;
> -#if YYLTYPE_IS_TRIVIAL
> -  /* Initialize the default location before parsing starts.  */
> -  yylloc.first_line   = yylloc.last_line   = 1;
> -  yylloc.first_column = yylloc.last_column = 0;
> -#endif
>  
>    goto yysetstate;
>  
> @@ -1294,7 +1252,6 @@ yyparse ()
>  	   memory.  */
>  	YYSTYPE *yyvs1 = yyvs;
>  	yytype_int16 *yyss1 = yyss;
> -	YYLTYPE *yyls1 = yyls;
>  
>  	/* Each stack pointer address is followed by the size of the
>  	   data in use in that stack, in bytes.  This used to be a
> @@ -1303,9 +1260,8 @@ yyparse ()
>  	yyoverflow (YY_("memory exhausted"),
>  		    &yyss1, yysize * sizeof (*yyssp),
>  		    &yyvs1, yysize * sizeof (*yyvsp),
> -		    &yyls1, yysize * sizeof (*yylsp),
>  		    &yystacksize);
> -	yyls = yyls1;
> +
>  	yyss = yyss1;
>  	yyvs = yyvs1;
>        }
> @@ -1326,9 +1282,8 @@ yyparse ()
>  	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
>  	if (! yyptr)
>  	  goto yyexhaustedlab;
> -	YYSTACK_RELOCATE (yyss);
> -	YYSTACK_RELOCATE (yyvs);
> -	YYSTACK_RELOCATE (yyls);
> +	YYSTACK_RELOCATE (yyss_alloc, yyss);
> +	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
>  #  undef YYSTACK_RELOCATE
>  	if (yyss1 != yyssa)
>  	  YYSTACK_FREE (yyss1);
> @@ -1338,7 +1293,6 @@ yyparse ()
>  
>        yyssp = yyss + yysize - 1;
>        yyvsp = yyvs + yysize - 1;
> -      yylsp = yyls + yysize - 1;
>  
>        YYDPRINTF ((stderr, "Stack size increased to %lu\n",
>  		  (unsigned long int) yystacksize));
> @@ -1349,6 +1303,9 @@ yyparse ()
>  
>    YYDPRINTF ((stderr, "Entering state %d\n", yystate));
>  
> +  if (yystate == YYFINAL)
> +    YYACCEPT;
> +
>    goto yybackup;
>  
>  /*-----------.
> @@ -1357,16 +1314,16 @@ yyparse ()
>  yybackup:
>  
>    /* Do appropriate processing given the current state.  Read a
> -     look-ahead token if we need one and don't already have one.  */
> +     lookahead token if we need one and don't already have one.  */
>  
> -  /* First try to decide what to do without reference to look-ahead token.  */
> +  /* First try to decide what to do without reference to lookahead token.  */
>    yyn = yypact[yystate];
>    if (yyn == YYPACT_NINF)
>      goto yydefault;
>  
> -  /* Not known => get a look-ahead token if don't already have one.  */
> +  /* Not known => get a lookahead token if don't already have one.  */
>  
> -  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
> +  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
>    if (yychar == YYEMPTY)
>      {
>        YYDPRINTF ((stderr, "Reading a token: "));
> @@ -1398,24 +1355,20 @@ yybackup:
>        goto yyreduce;
>      }
>  
> -  if (yyn == YYFINAL)
> -    YYACCEPT;
> -
>    /* Count tokens shifted since error; after three, turn off error
>       status.  */
>    if (yyerrstatus)
>      yyerrstatus--;
>  
> -  /* Shift the look-ahead token.  */
> +  /* Shift the lookahead token.  */
>    YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
>  
> -  /* Discard the shifted token unless it is eof.  */
> -  if (yychar != YYEOF)
> -    yychar = YYEMPTY;
> +  /* Discard the shifted token.  */
> +  yychar = YYEMPTY;
>  
>    yystate = yyn;
>    *++yyvsp = yylval;
> -  *++yylsp = yylloc;
> +
>    goto yynewstate;
>  
>  
> @@ -1446,337 +1399,387 @@ yyreduce:
>       GCC warning that YYVAL may be used uninitialized.  */
>    yyval = yyvsp[1-yylen];
>  
> -  /* Default location.  */
> -  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
> +
>    YY_REDUCE_PRINT (yyn);
>    switch (yyn)
>      {
>          case 2:
> -#line 90 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 87 "dtc-parser.y"
>      {
> -			the_boot_info = build_boot_info((yyvsp[(3) - (4)].re), (yyvsp[(4) - (4)].node), 0);
> +			the_boot_info = build_boot_info((yyvsp[(3) - (4)].re), (yyvsp[(4) - (4)].node),
> +							guess_boot_cpuid((yyvsp[(4) - (4)].node)));
>  		;}
>      break;
>  
>    case 3:
> -#line 94 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 95 "dtc-parser.y"
>      {
> -			the_boot_info = build_boot_info((yyvsp[(1) - (2)].re), (yyvsp[(2) - (2)].node), 0);
> +			(yyval.re) = NULL;
>  		;}
>      break;
>  
>    case 4:
> -#line 101 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 99 "dtc-parser.y"
>      {
> -			(yyval.re) = NULL;
> +			(yyval.re) = chain_reserve_entry((yyvsp[(1) - (2)].re), (yyvsp[(2) - (2)].re));
>  		;}
>      break;
>  
>    case 5:
> -#line 105 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 106 "dtc-parser.y"
>      {
> -			(yyval.re) = chain_reserve_entry((yyvsp[(1) - (2)].re), (yyvsp[(2) - (2)].re));
> +			(yyval.re) = build_reserve_entry((yyvsp[(2) - (4)].addr), (yyvsp[(3) - (4)].addr));
>  		;}
>      break;
>  
>    case 6:
> -#line 112 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 110 "dtc-parser.y"
>      {
> -			(yyval.re) = build_reserve_entry((yyvsp[(3) - (5)].addr), (yyvsp[(4) - (5)].addr), (yyvsp[(1) - (5)].labelref));
> +			add_label(&(yyvsp[(2) - (2)].re)->labels, (yyvsp[(1) - (2)].labelref));
> +			(yyval.re) = (yyvsp[(2) - (2)].re);
>  		;}
>      break;
>  
>    case 7:
> -#line 119 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 118 "dtc-parser.y"
>      {
> -			(yyval.re) = NULL;
> +			(yyval.addr) = eval_literal((yyvsp[(1) - (1)].literal), 0, 64);
>  		;}
>      break;
>  
>    case 8:
> -#line 123 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 125 "dtc-parser.y"
>      {
> -			(yyval.re) = chain_reserve_entry((yyvsp[(1) - (2)].re), (yyvsp[(2) - (2)].re));
> +			(yyval.node) = name_node((yyvsp[(2) - (2)].node), "");
>  		;}
>      break;
>  
>    case 9:
> -#line 130 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 129 "dtc-parser.y"
>      {
> -			(yyval.re) = (yyvsp[(1) - (1)].re);
> +			(yyval.node) = merge_nodes((yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node));
>  		;}
>      break;
>  
>    case 10:
> -#line 134 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 133 "dtc-parser.y"
>      {
> -			(yyval.re) = build_reserve_entry((yyvsp[(3) - (6)].addr), (yyvsp[(5) - (6)].addr) - (yyvsp[(3) - (6)].addr) + 1, (yyvsp[(1) - (6)].labelref));
> +			struct node *target = get_node_by_ref((yyvsp[(1) - (3)].node), (yyvsp[(2) - (3)].labelref));
> +
> +			if (target)
> +				merge_nodes(target, (yyvsp[(3) - (3)].node));
> +			else
> +				print_error("label or path, '%s', not found", (yyvsp[(2) - (3)].labelref));
> +			(yyval.node) = (yyvsp[(1) - (3)].node);
>  		;}
>      break;
>  
>    case 11:
> -#line 141 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 146 "dtc-parser.y"
>      {
> -			(yyval.addr) = eval_literal((yyvsp[(1) - (1)].literal), 0, 64);
> +			(yyval.node) = build_node((yyvsp[(2) - (5)].proplist), (yyvsp[(3) - (5)].nodelist));
>  		;}
>      break;
>  
>    case 12:
> -#line 145 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 153 "dtc-parser.y"
>      {
> -			(yyval.addr) = eval_literal((yyvsp[(1) - (1)].literal), 16, 64);
> +			(yyval.proplist) = NULL;
>  		;}
>      break;
>  
>    case 13:
> -#line 152 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 157 "dtc-parser.y"
>      {
> -			(yyval.node) = name_node((yyvsp[(2) - (2)].node), "", NULL);
> +			(yyval.proplist) = chain_property((yyvsp[(2) - (2)].prop), (yyvsp[(1) - (2)].proplist));
>  		;}
>      break;
>  
>    case 14:
> -#line 159 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 164 "dtc-parser.y"
>      {
> -			(yyval.node) = build_node((yyvsp[(2) - (5)].proplist), (yyvsp[(3) - (5)].nodelist));
> +			(yyval.prop) = build_property((yyvsp[(1) - (4)].propnodename), (yyvsp[(3) - (4)].data));
>  		;}
>      break;
>  
>    case 15:
> -#line 166 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 168 "dtc-parser.y"
>      {
> -			(yyval.proplist) = NULL;
> +			(yyval.prop) = build_property((yyvsp[(1) - (2)].propnodename), empty_data);
>  		;}
>      break;
>  
>    case 16:
> -#line 170 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 172 "dtc-parser.y"
>      {
> -			(yyval.proplist) = chain_property((yyvsp[(2) - (2)].prop), (yyvsp[(1) - (2)].proplist));
> +			add_label(&(yyvsp[(2) - (2)].prop)->labels, (yyvsp[(1) - (2)].labelref));
> +			(yyval.prop) = (yyvsp[(2) - (2)].prop);
>  		;}
>      break;
>  
>    case 17:
> -#line 177 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 180 "dtc-parser.y"
>      {
> -			(yyval.prop) = build_property((yyvsp[(2) - (5)].propnodename), (yyvsp[(4) - (5)].data), (yyvsp[(1) - (5)].labelref));
> +			(yyval.data) = data_merge((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].data));
>  		;}
>      break;
>  
>    case 18:
> -#line 181 "dtc-parser.y"
> +
> +/* Line 1455 of yacc.c  */
> +#line 184 "dtc-parser.y"
>      {
> -			(yyval.prop) = build_property((yyvsp[(2) - (3)].propnodename), empty_data, (yyvsp[(1) - (3)].labelref));
> +			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
>  		;}
>      break;
>  
>    case 19:
> +
> +/* Line 1455 of yacc.c  */
>  #line 188 "dtc-parser.y"
>      {
> -			(yyval.data) = data_merge((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].data));
> +			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
>  		;}
>      break;
>  
>    case 20:
> +
> +/* Line 1455 of yacc.c  */
>  #line 192 "dtc-parser.y"
>      {
> -			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
> +			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), REF_PATH, (yyvsp[(2) - (2)].labelref));
>  		;}
>      break;
>  
>    case 21:
> -#line 196 "dtc-parser.y"
> -    {
> -			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
> -		;}
> -    break;
> -
> -  case 22:
> -#line 200 "dtc-parser.y"
> -    {
> -			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), REF_PATH, (yyvsp[(2) - (2)].labelref));
> -		;}
> -    break;
>  
> -  case 23:
> -#line 204 "dtc-parser.y"
> +/* Line 1455 of yacc.c  */
> +#line 196 "dtc-parser.y"
>      {
> -			struct search_path path = { srcpos_file->dir, NULL, NULL };
> -			struct dtc_file *file = dtc_open_file((yyvsp[(4) - (9)].data).val, &path);
> -			struct data d = empty_data;
> +			FILE *f = srcfile_relative_open((yyvsp[(4) - (9)].data).val, NULL);
> +			struct data d;
>  
>  			if ((yyvsp[(6) - (9)].addr) != 0)
> -				if (fseek(file->file, (yyvsp[(6) - (9)].addr), SEEK_SET) != 0)
> -					yyerrorf("Couldn't seek to offset %llu in \"%s\": %s",
> -						 (unsigned long long)(yyvsp[(6) - (9)].addr),
> -						 (yyvsp[(4) - (9)].data).val, strerror(errno));
> +				if (fseek(f, (yyvsp[(6) - (9)].addr), SEEK_SET) != 0)
> +					print_error("Couldn't seek to offset %llu in \"%s\": %s",
> +						     (unsigned long long)(yyvsp[(6) - (9)].addr),
> +						     (yyvsp[(4) - (9)].data).val,
> +						     strerror(errno));
>  
> -			d = data_copy_file(file->file, (yyvsp[(8) - (9)].addr));
> +			d = data_copy_file(f, (yyvsp[(8) - (9)].addr));
>  
>  			(yyval.data) = data_merge((yyvsp[(1) - (9)].data), d);
> -			dtc_close_file(file);
> +			fclose(f);
>  		;}
>      break;
>  
> -  case 24:
> -#line 221 "dtc-parser.y"
> +  case 22:
> +
> +/* Line 1455 of yacc.c  */
> +#line 213 "dtc-parser.y"
>      {
> -			struct search_path path = { srcpos_file->dir, NULL, NULL };
> -			struct dtc_file *file = dtc_open_file((yyvsp[(4) - (5)].data).val, &path);
> +			FILE *f = srcfile_relative_open((yyvsp[(4) - (5)].data).val, NULL);
>  			struct data d = empty_data;
>  
> -			d = data_copy_file(file->file, -1);
> +			d = data_copy_file(f, -1);
>  
>  			(yyval.data) = data_merge((yyvsp[(1) - (5)].data), d);
> -			dtc_close_file(file);
> +			fclose(f);
>  		;}
>      break;
>  
> -  case 25:
> -#line 232 "dtc-parser.y"
> +  case 23:
> +
> +/* Line 1455 of yacc.c  */
> +#line 223 "dtc-parser.y"
>      {
>  			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
>  		;}
>      break;
>  
> -  case 26:
> -#line 239 "dtc-parser.y"
> +  case 24:
> +
> +/* Line 1455 of yacc.c  */
> +#line 230 "dtc-parser.y"
>      {
>  			(yyval.data) = empty_data;
>  		;}
>      break;
>  
> -  case 27:
> -#line 243 "dtc-parser.y"
> +  case 25:
> +
> +/* Line 1455 of yacc.c  */
> +#line 234 "dtc-parser.y"
>      {
>  			(yyval.data) = (yyvsp[(1) - (2)].data);
>  		;}
>      break;
>  
> -  case 28:
> -#line 247 "dtc-parser.y"
> +  case 26:
> +
> +/* Line 1455 of yacc.c  */
> +#line 238 "dtc-parser.y"
>      {
>  			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
>  		;}
>      break;
>  
> -  case 29:
> -#line 254 "dtc-parser.y"
> +  case 27:
> +
> +/* Line 1455 of yacc.c  */
> +#line 245 "dtc-parser.y"
>      {
>  			(yyval.data) = empty_data;
>  		;}
>      break;
>  
> -  case 30:
> -#line 258 "dtc-parser.y"
> +  case 28:
> +
> +/* Line 1455 of yacc.c  */
> +#line 249 "dtc-parser.y"
>      {
>  			(yyval.data) = data_append_cell((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].cell));
>  		;}
>      break;
>  
> -  case 31:
> -#line 262 "dtc-parser.y"
> +  case 29:
> +
> +/* Line 1455 of yacc.c  */
> +#line 253 "dtc-parser.y"
>      {
>  			(yyval.data) = data_append_cell(data_add_marker((yyvsp[(1) - (2)].data), REF_PHANDLE,
>  							      (yyvsp[(2) - (2)].labelref)), -1);
>  		;}
>      break;
>  
> -  case 32:
> -#line 267 "dtc-parser.y"
> +  case 30:
> +
> +/* Line 1455 of yacc.c  */
> +#line 258 "dtc-parser.y"
>      {
>  			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
>  		;}
>      break;
>  
> -  case 33:
> -#line 274 "dtc-parser.y"
> -    {
> -			(yyval.cbase) = 16;
> -		;}
> -    break;
> +  case 31:
>  
> -  case 35:
> -#line 282 "dtc-parser.y"
> +/* Line 1455 of yacc.c  */
> +#line 265 "dtc-parser.y"
>      {
>  			(yyval.cell) = eval_literal((yyvsp[(1) - (1)].literal), 0, 32);
>  		;}
>      break;
>  
> -  case 36:
> -#line 286 "dtc-parser.y"
> -    {
> -			(yyval.cell) = eval_literal((yyvsp[(2) - (2)].literal), (yyvsp[(1) - (2)].cbase), 32);
> -		;}
> -    break;
> +  case 32:
>  
> -  case 37:
> -#line 293 "dtc-parser.y"
> +/* Line 1455 of yacc.c  */
> +#line 272 "dtc-parser.y"
>      {
>  			(yyval.data) = empty_data;
>  		;}
>      break;
>  
> -  case 38:
> -#line 297 "dtc-parser.y"
> +  case 33:
> +
> +/* Line 1455 of yacc.c  */
> +#line 276 "dtc-parser.y"
>      {
>  			(yyval.data) = data_append_byte((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].byte));
>  		;}
>      break;
>  
> -  case 39:
> -#line 301 "dtc-parser.y"
> +  case 34:
> +
> +/* Line 1455 of yacc.c  */
> +#line 280 "dtc-parser.y"
>      {
>  			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
>  		;}
>      break;
>  
> -  case 40:
> -#line 308 "dtc-parser.y"
> +  case 35:
> +
> +/* Line 1455 of yacc.c  */
> +#line 287 "dtc-parser.y"
>      {
>  			(yyval.nodelist) = NULL;
>  		;}
>      break;
>  
> -  case 41:
> -#line 312 "dtc-parser.y"
> +  case 36:
> +
> +/* Line 1455 of yacc.c  */
> +#line 291 "dtc-parser.y"
>      {
>  			(yyval.nodelist) = chain_node((yyvsp[(1) - (2)].node), (yyvsp[(2) - (2)].nodelist));
>  		;}
>      break;
>  
> -  case 42:
> -#line 316 "dtc-parser.y"
> +  case 37:
> +
> +/* Line 1455 of yacc.c  */
> +#line 295 "dtc-parser.y"
>      {
> -			yyerror("syntax error: properties must precede subnodes");
> +			print_error("syntax error: properties must precede subnodes");
>  			YYERROR;
>  		;}
>      break;
>  
> -  case 43:
> -#line 324 "dtc-parser.y"
> -    {
> -			(yyval.node) = name_node((yyvsp[(3) - (3)].node), (yyvsp[(2) - (3)].propnodename), (yyvsp[(1) - (3)].labelref));
> -		;}
> -    break;
> +  case 38:
>  
> -  case 44:
> -#line 331 "dtc-parser.y"
> +/* Line 1455 of yacc.c  */
> +#line 303 "dtc-parser.y"
>      {
> -			(yyval.labelref) = NULL;
> +			(yyval.node) = name_node((yyvsp[(2) - (2)].node), (yyvsp[(1) - (2)].propnodename));
>  		;}
>      break;
>  
> -  case 45:
> -#line 335 "dtc-parser.y"
> +  case 39:
> +
> +/* Line 1455 of yacc.c  */
> +#line 307 "dtc-parser.y"
>      {
> -			(yyval.labelref) = (yyvsp[(1) - (1)].labelref);
> +			add_label(&(yyvsp[(2) - (2)].node)->labels, (yyvsp[(1) - (2)].labelref));
> +			(yyval.node) = (yyvsp[(2) - (2)].node);
>  		;}
>      break;
>  
>  
> -/* Line 1267 of yacc.c.  */
> -#line 1780 "dtc-parser.tab.c"
> +
> +/* Line 1455 of yacc.c  */
> +#line 1783 "dtc-parser.tab.c"
>        default: break;
>      }
>    YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
> @@ -1786,7 +1789,6 @@ yyreduce:
>    YY_STACK_PRINT (yyss, yyssp);
>  
>    *++yyvsp = yyval;
> -  *++yylsp = yyloc;
>  
>    /* Now `shift' the result of the reduction.  Determine what state
>       that goes to, based on the state we popped back to and the rule
> @@ -1848,11 +1850,11 @@ yyerrlab:
>  #endif
>      }
>  
> -  yyerror_range[0] = yylloc;
> +
>  
>    if (yyerrstatus == 3)
>      {
> -      /* If just tried and failed to reuse look-ahead token after an
> +      /* If just tried and failed to reuse lookahead token after an
>  	 error, discard it.  */
>  
>        if (yychar <= YYEOF)
> @@ -1864,12 +1866,12 @@ yyerrlab:
>        else
>  	{
>  	  yydestruct ("Error: discarding",
> -		      yytoken, &yylval, &yylloc);
> +		      yytoken, &yylval);
>  	  yychar = YYEMPTY;
>  	}
>      }
>  
> -  /* Else will try to reuse look-ahead token after shifting the error
> +  /* Else will try to reuse lookahead token after shifting the error
>       token.  */
>    goto yyerrlab1;
>  
> @@ -1885,7 +1887,6 @@ yyerrorlab:
>    if (/*CONSTCOND*/ 0)
>       goto yyerrorlab;
>  
> -  yyerror_range[0] = yylsp[1-yylen];
>    /* Do not reclaim the symbols of the rule which action triggered
>       this YYERROR.  */
>    YYPOPSTACK (yylen);
> @@ -1919,24 +1920,16 @@ yyerrlab1:
>        if (yyssp == yyss)
>  	YYABORT;
>  
> -      yyerror_range[0] = *yylsp;
> +
>        yydestruct ("Error: popping",
> -		  yystos[yystate], yyvsp, yylsp);
> +		  yystos[yystate], yyvsp);
>        YYPOPSTACK (1);
>        yystate = *yyssp;
>        YY_STACK_PRINT (yyss, yyssp);
>      }
>  
> -  if (yyn == YYFINAL)
> -    YYACCEPT;
> -
>    *++yyvsp = yylval;
>  
> -  yyerror_range[1] = yylloc;
> -  /* Using YYLLOC is tempting, but would change the location of
> -     the look-ahead.  YYLOC is available though.  */
> -  YYLLOC_DEFAULT (yyloc, (yyerror_range - 1), 2);
> -  *++yylsp = yyloc;
>  
>    /* Shift the error token.  */
>    YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);
> @@ -1959,7 +1952,7 @@ yyabortlab:
>    yyresult = 1;
>    goto yyreturn;
>  
> -#ifndef yyoverflow
> +#if !defined(yyoverflow) || YYERROR_VERBOSE
>  /*-------------------------------------------------.
>  | yyexhaustedlab -- memory exhaustion comes here.  |
>  `-------------------------------------------------*/
> @@ -1970,9 +1963,9 @@ yyexhaustedlab:
>  #endif
>  
>  yyreturn:
> -  if (yychar != YYEOF && yychar != YYEMPTY)
> +  if (yychar != YYEMPTY)
>       yydestruct ("Cleanup: discarding lookahead",
> -		 yytoken, &yylval, &yylloc);
> +		 yytoken, &yylval);
>    /* Do not reclaim the symbols of the rule which action triggered
>       this YYABORT or YYACCEPT.  */
>    YYPOPSTACK (yylen);
> @@ -1980,7 +1973,7 @@ yyreturn:
>    while (yyssp != yyss)
>      {
>        yydestruct ("Cleanup: popping",
> -		  yystos[*yyssp], yyvsp, yylsp);
> +		  yystos[*yyssp], yyvsp);
>        YYPOPSTACK (1);
>      }
>  #ifndef yyoverflow
> @@ -1996,29 +1989,24 @@ yyreturn:
>  }
>  
>  
> -#line 340 "dtc-parser.y"
> +
> +/* Line 1675 of yacc.c  */
> +#line 313 "dtc-parser.y"
>  
>  
> -void yyerrorf(char const *s, ...)
> +void print_error(char const *fmt, ...)
>  {
> -	const char *fname = srcpos_file ? srcpos_file->name : "<no-file>";
>  	va_list va;
> -	va_start(va, s);
> -
> -	if (strcmp(fname, "-") == 0)
> -		fname = "stdin";
>  
> -	fprintf(stderr, "%s:%d ", fname, yylloc.first_line);
> -	vfprintf(stderr, s, va);
> -	fprintf(stderr, "\n");
> +	va_start(va, fmt);
> +	srcpos_verror(&yylloc, fmt, va);
> +	va_end(va);
>  
>  	treesource_error = 1;
> -	va_end(va);
>  }
>  
> -void yyerror (char const *s)
> -{
> -	yyerrorf("%s", s);
> +void yyerror(char const *s) {
> +	print_error("%s", s);
>  }
>  
>  static unsigned long long eval_literal(const char *s, int base, int bits)
> @@ -2029,12 +2017,12 @@ static unsigned long long eval_literal(const char *s, int base, int bits)
>  	errno = 0;
>  	val = strtoull(s, &e, base);
>  	if (*e)
> -		yyerror("bad characters in literal");
> +		print_error("bad characters in literal");
>  	else if ((errno == ERANGE)
>  		 || ((bits < 64) && (val >= (1ULL << bits))))
> -		yyerror("literal out of range");
> +		print_error("literal out of range");
>  	else if (errno != 0)
> -		yyerror("bad literal");
> +		print_error("bad literal");
>  	return val;
>  }
>  
> diff --git a/scripts/dtc/dtc-parser.tab.h_shipped b/scripts/dtc/dtc-parser.tab.h_shipped
> index ba99100..95c9547 100644
> --- a/scripts/dtc/dtc-parser.tab.h_shipped
> +++ b/scripts/dtc/dtc-parser.tab.h_shipped
> @@ -1,24 +1,23 @@
> -/* A Bison parser, made by GNU Bison 2.3.  */
>  
> -/* Skeleton interface for Bison's Yacc-like parsers in C
> +/* A Bison parser, made by GNU Bison 2.4.1.  */
>  
> -   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
> +/* Skeleton interface for Bison's Yacc-like parsers in C
> +   
> +      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
>     Free Software Foundation, Inc.
> -
> -   This program is free software; you can redistribute it and/or modify
> +   
> +   This program is free software: you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
> -   the Free Software Foundation; either version 2, or (at your option)
> -   any later version.
> -
> +   the Free Software Foundation, either version 3 of the License, or
> +   (at your option) any later version.
> +   
>     This program is distributed in the hope that it will be useful,
>     but WITHOUT ANY WARRANTY; without even the implied warranty of
>     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>     GNU General Public License for more details.
> -
> +   
>     You should have received a copy of the GNU General Public License
> -   along with this program; if not, write to the Free Software
> -   Foundation, Inc., 51 Franklin Street, Fifth Floor,
> -   Boston, MA 02110-1301, USA.  */
> +   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
>  
>  /* As a special exception, you may create a larger work that contains
>     part or all of the Bison parser skeleton and distribute that work
> @@ -29,10 +28,11 @@
>     special exception, which will cause the skeleton and the resulting
>     Bison output files to be licensed under the GNU General Public
>     License without this special exception.
> -
> +   
>     This special exception was added by the Free Software Foundation in
>     version 2.2 of Bison.  */
>  
> +
>  /* Tokens.  */
>  #ifndef YYTOKENTYPE
>  # define YYTOKENTYPE
> @@ -43,35 +43,24 @@
>       DT_MEMRESERVE = 259,
>       DT_PROPNODENAME = 260,
>       DT_LITERAL = 261,
> -     DT_LEGACYLITERAL = 262,
> -     DT_BASE = 263,
> -     DT_BYTE = 264,
> -     DT_STRING = 265,
> -     DT_LABEL = 266,
> -     DT_REF = 267,
> -     DT_INCBIN = 268
> +     DT_BASE = 262,
> +     DT_BYTE = 263,
> +     DT_STRING = 264,
> +     DT_LABEL = 265,
> +     DT_REF = 266,
> +     DT_INCBIN = 267
>     };
>  #endif
> -/* Tokens.  */
> -#define DT_V1 258
> -#define DT_MEMRESERVE 259
> -#define DT_PROPNODENAME 260
> -#define DT_LITERAL 261
> -#define DT_LEGACYLITERAL 262
> -#define DT_BASE 263
> -#define DT_BYTE 264
> -#define DT_STRING 265
> -#define DT_LABEL 266
> -#define DT_REF 267
> -#define DT_INCBIN 268
> -
>  
>  
>  
>  #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
>  typedef union YYSTYPE
> -#line 37 "dtc-parser.y"
>  {
> +
> +/* Line 1676 of yacc.c  */
> +#line 39 "dtc-parser.y"
> +
>  	char *propnodename;
>  	char *literal;
>  	char *labelref;
> @@ -86,28 +75,17 @@ typedef union YYSTYPE
>  	struct node *node;
>  	struct node *nodelist;
>  	struct reserve_info *re;
> -}
> -/* Line 1489 of yacc.c.  */
> -#line 92 "dtc-parser.tab.h"
> -	YYSTYPE;
> +
> +
> +
> +/* Line 1676 of yacc.c  */
> +#line 83 "dtc-parser.tab.h"
> +} YYSTYPE;
> +# define YYSTYPE_IS_TRIVIAL 1
>  # define yystype YYSTYPE /* obsolescent; will be withdrawn */
>  # define YYSTYPE_IS_DECLARED 1
> -# define YYSTYPE_IS_TRIVIAL 1
>  #endif
>  
>  extern YYSTYPE yylval;
>  
> -#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
> -typedef struct YYLTYPE
> -{
> -  int first_line;
> -  int first_column;
> -  int last_line;
> -  int last_column;
> -} YYLTYPE;
> -# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
> -# define YYLTYPE_IS_DECLARED 1
> -# define YYLTYPE_IS_TRIVIAL 1
> -#endif
>  
> -extern YYLTYPE yylloc;
> diff --git a/scripts/dtc/dtc-parser.y b/scripts/dtc/dtc-parser.y
> index b2ab562..5e84a67 100644
> --- a/scripts/dtc/dtc-parser.y
> +++ b/scripts/dtc/dtc-parser.y
> @@ -18,15 +18,17 @@
>   *                                                                   USA
>   */
>  
> -%locations
> -
>  %{
>  #include <stdio.h>
>  
>  #include "dtc.h"
>  #include "srcpos.h"
>  
> +YYLTYPE yylloc;
> +
>  extern int yylex(void);
> +extern void print_error(char const *fmt, ...);
> +extern void yyerror(char const *s);
>  
>  extern struct boot_info *the_boot_info;
>  extern int treesource_error;
> @@ -55,7 +57,6 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
>  %token DT_MEMRESERVE
>  %token <propnodename> DT_PROPNODENAME
>  %token <literal> DT_LITERAL
> -%token <literal> DT_LEGACYLITERAL
>  %token <cbase> DT_BASE
>  %token <byte> DT_BYTE
>  %token <data> DT_STRING
> @@ -67,11 +68,8 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
>  %type <data> propdataprefix
>  %type <re> memreserve
>  %type <re> memreserves
> -%type <re> v0_memreserve
> -%type <re> v0_memreserves
>  %type <addr> addr
>  %type <data> celllist
> -%type <cbase> cellbase
>  %type <cell> cellval
>  %type <data> bytestring
>  %type <prop> propdef
> @@ -81,18 +79,14 @@ static unsigned long long eval_literal(const char *s, int base, int bits);
>  %type <node> nodedef
>  %type <node> subnode
>  %type <nodelist> subnodes
> -%type <labelref> label
>  
>  %%
>  
>  sourcefile:
>  	  DT_V1 ';' memreserves devicetree
>  		{
> -			the_boot_info = build_boot_info($3, $4, 0);
> -		}
> -	| v0_memreserves devicetree
> -		{
> -			the_boot_info = build_boot_info($1, $2, 0);
> +			the_boot_info = build_boot_info($3, $4,
> +							guess_boot_cpuid($4));
>  		}
>  	;
>  
> @@ -108,31 +102,14 @@ memreserves:
>  	;
>  
>  memreserve:
> -	  label DT_MEMRESERVE addr addr ';'
> +	  DT_MEMRESERVE addr addr ';'
>  		{
> -			$$ = build_reserve_entry($3, $4, $1);
> +			$$ = build_reserve_entry($2, $3);
>  		}
> -	;
> -
> -v0_memreserves:
> -	  /* empty */
> +	| DT_LABEL memreserve
>  		{
> -			$$ = NULL;
> -		}
> -	| v0_memreserve v0_memreserves
> -		{
> -			$$ = chain_reserve_entry($1, $2);
> -		};
> -	;
> -
> -v0_memreserve:
> -	  memreserve
> -		{
> -			$$ = $1;
> -		}
> -	| label DT_MEMRESERVE addr '-' addr ';'
> -		{
> -			$$ = build_reserve_entry($3, $5 - $3 + 1, $1);
> +			add_label(&$2->labels, $1);
> +			$$ = $2;
>  		}
>  	;
>  
> @@ -141,16 +118,26 @@ addr:
>  		{
>  			$$ = eval_literal($1, 0, 64);
>  		}
> -	| DT_LEGACYLITERAL
> -		{
> -			$$ = eval_literal($1, 16, 64);
> -		}
>  	  ;
>  
>  devicetree:
>  	  '/' nodedef
>  		{
> -			$$ = name_node($2, "", NULL);
> +			$$ = name_node($2, "");
> +		}
> +	| devicetree '/' nodedef
> +		{
> +			$$ = merge_nodes($1, $3);
> +		}
> +	| devicetree DT_REF nodedef
> +		{
> +			struct node *target = get_node_by_ref($1, $2);
> +
> +			if (target)
> +				merge_nodes(target, $3);
> +			else
> +				print_error("label or path, '%s', not found", $2);
> +			$$ = $1;
>  		}
>  	;
>  
> @@ -173,13 +160,18 @@ proplist:
>  	;
>  
>  propdef:
> -	  label DT_PROPNODENAME '=' propdata ';'
> +	  DT_PROPNODENAME '=' propdata ';'
> +		{
> +			$$ = build_property($1, $3);
> +		}
> +	| DT_PROPNODENAME ';'
>  		{
> -			$$ = build_property($2, $4, $1);
> +			$$ = build_property($1, empty_data);
>  		}
> -	| label DT_PROPNODENAME ';'
> +	| DT_LABEL propdef
>  		{
> -			$$ = build_property($2, empty_data, $1);
> +			add_label(&$2->labels, $1);
> +			$$ = $2;
>  		}
>  	;
>  
> @@ -202,31 +194,30 @@ propdata:
>  		}
>  	| propdataprefix DT_INCBIN '(' DT_STRING ',' addr ',' addr ')'
>  		{
> -			struct search_path path = { srcpos_file->dir, NULL, NULL };
> -			struct dtc_file *file = dtc_open_file($4.val, &path);
> -			struct data d = empty_data;
> +			FILE *f = srcfile_relative_open($4.val, NULL);
> +			struct data d;
>  
>  			if ($6 != 0)
> -				if (fseek(file->file, $6, SEEK_SET) != 0)
> -					yyerrorf("Couldn't seek to offset %llu in \"%s\": %s",
> -						 (unsigned long long)$6,
> -						 $4.val, strerror(errno));
> +				if (fseek(f, $6, SEEK_SET) != 0)
> +					print_error("Couldn't seek to offset %llu in \"%s\": %s",
> +						     (unsigned long long)$6,
> +						     $4.val,
> +						     strerror(errno));
>  
> -			d = data_copy_file(file->file, $8);
> +			d = data_copy_file(f, $8);
>  
>  			$$ = data_merge($1, d);
> -			dtc_close_file(file);
> +			fclose(f);
>  		}
>  	| propdataprefix DT_INCBIN '(' DT_STRING ')'
>  		{
> -			struct search_path path = { srcpos_file->dir, NULL, NULL };
> -			struct dtc_file *file = dtc_open_file($4.val, &path);
> +			FILE *f = srcfile_relative_open($4.val, NULL);
>  			struct data d = empty_data;
>  
> -			d = data_copy_file(file->file, -1);
> +			d = data_copy_file(f, -1);
>  
>  			$$ = data_merge($1, d);
> -			dtc_close_file(file);
> +			fclose(f);
>  		}
>  	| propdata DT_LABEL
>  		{
> @@ -269,23 +260,11 @@ celllist:
>  		}
>  	;
>  
> -cellbase:
> -	  /* empty */
> -		{
> -			$$ = 16;
> -		}
> -	| DT_BASE
> -	;
> -
>  cellval:
>  	  DT_LITERAL
>  		{
>  			$$ = eval_literal($1, 0, 32);
>  		}
> -	| cellbase DT_LEGACYLITERAL
> -		{
> -			$$ = eval_literal($2, $1, 32);
> -		}
>  	;
>  
>  bytestring:
> @@ -308,57 +287,44 @@ subnodes:
>  		{
>  			$$ = NULL;
>  		}
> -	|  subnode subnodes
> +	| subnode subnodes
>  		{
>  			$$ = chain_node($1, $2);
>  		}
>  	| subnode propdef
>  		{
> -			yyerror("syntax error: properties must precede subnodes");
> +			print_error("syntax error: properties must precede subnodes");
>  			YYERROR;
>  		}
>  	;
>  
>  subnode:
> -	  label DT_PROPNODENAME nodedef
> +	  DT_PROPNODENAME nodedef
>  		{
> -			$$ = name_node($3, $2, $1);
> +			$$ = name_node($2, $1);
>  		}
> -	;
> -
> -label:
> -	  /* empty */
> +	| DT_LABEL subnode
>  		{
> -			$$ = NULL;
> -		}
> -	| DT_LABEL
> -		{
> -			$$ = $1;
> +			add_label(&$2->labels, $1);
> +			$$ = $2;
>  		}
>  	;
>  
>  %%
>  
> -void yyerrorf(char const *s, ...)
> +void print_error(char const *fmt, ...)
>  {
> -	const char *fname = srcpos_file ? srcpos_file->name : "<no-file>";
>  	va_list va;
> -	va_start(va, s);
> -
> -	if (strcmp(fname, "-") == 0)
> -		fname = "stdin";
>  
> -	fprintf(stderr, "%s:%d ", fname, yylloc.first_line);
> -	vfprintf(stderr, s, va);
> -	fprintf(stderr, "\n");
> +	va_start(va, fmt);
> +	srcpos_verror(&yylloc, fmt, va);
> +	va_end(va);
>  
>  	treesource_error = 1;
> -	va_end(va);
>  }
>  
> -void yyerror (char const *s)
> -{
> -	yyerrorf("%s", s);
> +void yyerror(char const *s) {
> +	print_error("%s", s);
>  }
>  
>  static unsigned long long eval_literal(const char *s, int base, int bits)
> @@ -369,11 +335,11 @@ static unsigned long long eval_literal(const char *s, int base, int bits)
>  	errno = 0;
>  	val = strtoull(s, &e, base);
>  	if (*e)
> -		yyerror("bad characters in literal");
> +		print_error("bad characters in literal");
>  	else if ((errno == ERANGE)
>  		 || ((bits < 64) && (val >= (1ULL << bits))))
> -		yyerror("literal out of range");
> +		print_error("literal out of range");
>  	else if (errno != 0)
> -		yyerror("bad literal");
> +		print_error("bad literal");
>  	return val;
>  }
> diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
> index d8fd43b..cbc0193 100644
> --- a/scripts/dtc/dtc.c
> +++ b/scripts/dtc/dtc.c
> @@ -30,30 +30,7 @@ int quiet;		/* Level of quietness */
>  int reservenum;		/* Number of memory reservation slots */
>  int minsize;		/* Minimum blob size */
>  int padsize;		/* Additional padding to blob */
> -
> -char *join_path(const char *path, const char *name)
> -{
> -	int lenp = strlen(path);
> -	int lenn = strlen(name);
> -	int len;
> -	int needslash = 1;
> -	char *str;
> -
> -	len = lenp + lenn + 2;
> -	if ((lenp > 0) && (path[lenp-1] == '/')) {
> -		needslash = 0;
> -		len--;
> -	}
> -
> -	str = xmalloc(len);
> -	memcpy(str, path, lenp);
> -	if (needslash) {
> -		str[lenp] = '/';
> -		lenp++;
> -	}
> -	memcpy(str+lenp, name, lenn+1);
> -	return str;
> -}
> +int phandle_format = PHANDLE_BOTH;	/* Use linux,phandle or phandle properties */
>  
>  static void fill_fullpaths(struct node *tree, const char *prefix)
>  {
> @@ -104,8 +81,15 @@ static void  __attribute__ ((noreturn)) usage(void)
>  	fprintf(stderr, "\t\tSet the physical boot cpu\n");
>  	fprintf(stderr, "\t-f\n");
>  	fprintf(stderr, "\t\tForce - try to produce output even if the input tree has errors\n");
> +	fprintf(stderr, "\t-s\n");
> +	fprintf(stderr, "\t\tSort nodes and properties before outputting (only useful for\n\t\tcomparing trees)\n");
>  	fprintf(stderr, "\t-v\n");
>  	fprintf(stderr, "\t\tPrint DTC version and exit\n");
> +	fprintf(stderr, "\t-H <phandle format>\n");
> +	fprintf(stderr, "\t\tphandle formats are:\n");
> +	fprintf(stderr, "\t\t\tlegacy - \"linux,phandle\" properties only\n");
> +	fprintf(stderr, "\t\t\tepapr - \"phandle\" properties only\n");
> +	fprintf(stderr, "\t\t\tboth - Both \"linux,phandle\" and \"phandle\" properties\n");
>  	exit(3);
>  }
>  
> @@ -115,7 +99,7 @@ int main(int argc, char *argv[])
>  	const char *inform = "dts";
>  	const char *outform = "dts";
>  	const char *outname = "-";
> -	int force = 0, check = 0;
> +	int force = 0, check = 0, sort = 0;
>  	const char *arg;
>  	int opt;
>  	FILE *outf = NULL;
> @@ -127,7 +111,7 @@ int main(int argc, char *argv[])
>  	minsize    = 0;
>  	padsize    = 0;
>  
> -	while ((opt = getopt(argc, argv, "hI:O:o:V:R:S:p:fcqb:v")) != EOF) {
> +	while ((opt = getopt(argc, argv, "hI:O:o:V:R:S:p:fcqb:vH:s")) != EOF) {
>  		switch (opt) {
>  		case 'I':
>  			inform = optarg;
> @@ -165,6 +149,22 @@ int main(int argc, char *argv[])
>  		case 'v':
>  			printf("Version: %s\n", DTC_VERSION);
>  			exit(0);
> +		case 'H':
> +			if (streq(optarg, "legacy"))
> +				phandle_format = PHANDLE_LEGACY;
> +			else if (streq(optarg, "epapr"))
> +				phandle_format = PHANDLE_EPAPR;
> +			else if (streq(optarg, "both"))
> +				phandle_format = PHANDLE_BOTH;
> +			else
> +				die("Invalid argument \"%s\" to -H option\n",
> +				    optarg);
> +			break;
> +
> +		case 's':
> +			sort = 1;
> +			break;
> +
>  		case 'h':
>  		default:
>  			usage();
> @@ -182,6 +182,9 @@ int main(int argc, char *argv[])
>  	if (minsize && padsize)
>  		die("Can't set both -p and -S\n");
>  
> +	if (minsize)
> +		fprintf(stderr, "DTC: Use of \"-S\" is deprecated; it will be removed soon, use \"-p\" instead\n");
> +
>  	fprintf(stderr, "DTC: %s->%s  on file \"%s\"\n",
>  		inform, outform, arg);
>  
> @@ -200,6 +203,8 @@ int main(int argc, char *argv[])
>  	fill_fullpaths(bi->dt, "");
>  	process_checks(force, bi);
>  
> +	if (sort)
> +		sort_tree(bi);
>  
>  	if (streq(outname, "-")) {
>  		outf = stdout;
> diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
> index 08d54c8..f37c97e 100644
> --- a/scripts/dtc/dtc.h
> +++ b/scripts/dtc/dtc.h
> @@ -34,7 +34,17 @@
>  #include <libfdt_env.h>
>  #include <fdt.h>
>  
> +#include "util.h"
> +
> +#ifdef DEBUG
> +#define debug(fmt,args...)	printf(fmt, ##args)
> +#else
> +#define debug(fmt,args...)
> +#endif
> +
> +
>  #define DEFAULT_FDT_VERSION	17
> +
>  /*
>   * Command line options
>   */
> @@ -42,36 +52,11 @@ extern int quiet;		/* Level of quietness */
>  extern int reservenum;		/* Number of memory reservation slots */
>  extern int minsize;		/* Minimum blob size */
>  extern int padsize;		/* Additional padding to blob */
> +extern int phandle_format;	/* Use linux,phandle or phandle properties */
>  
> -static inline void __attribute__((noreturn)) die(char * str, ...)
> -{
> -	va_list ap;
> -
> -	va_start(ap, str);
> -	fprintf(stderr, "FATAL ERROR: ");
> -	vfprintf(stderr, str, ap);
> -	exit(1);
> -}
> -
> -static inline void *xmalloc(size_t len)
> -{
> -	void *new = malloc(len);
> -
> -	if (! new)
> -		die("malloc() failed\n");
> -
> -	return new;
> -}
> -
> -static inline void *xrealloc(void *p, size_t len)
> -{
> -	void *new = realloc(p, len);
> -
> -	if (! new)
> -		die("realloc() failed (len=%d)\n", len);
> -
> -	return new;
> -}
> +#define PHANDLE_LEGACY	0x1
> +#define PHANDLE_EPAPR	0x2
> +#define PHANDLE_BOTH	0x3
>  
>  typedef uint32_t cell_t;
>  
> @@ -140,13 +125,18 @@ int data_is_one_string(struct data d);
>  #define MAX_NODENAME_LEN	31
>  
>  /* Live trees */
> +struct label {
> +	char *label;
> +	struct label *next;
> +};
> +
>  struct property {
>  	char *name;
>  	struct data val;
>  
>  	struct property *next;
>  
> -	char *label;
> +	struct label *labels;
>  };
>  
>  struct node {
> @@ -163,22 +153,28 @@ struct node {
>  	cell_t phandle;
>  	int addr_cells, size_cells;
>  
> -	char *label;
> +	struct label *labels;
>  };
>  
> +#define for_each_label(l0, l) \
> +	for ((l) = (l0); (l); (l) = (l)->next)
> +
>  #define for_each_property(n, p) \
>  	for ((p) = (n)->proplist; (p); (p) = (p)->next)
>  
>  #define for_each_child(n, c)	\
>  	for ((c) = (n)->children; (c); (c) = (c)->next_sibling)
>  
> -struct property *build_property(char *name, struct data val, char *label);
> +void add_label(struct label **labels, char *label);
> +
> +struct property *build_property(char *name, struct data val);
>  struct property *chain_property(struct property *first, struct property *list);
>  struct property *reverse_properties(struct property *first);
>  
>  struct node *build_node(struct property *proplist, struct node *children);
> -struct node *name_node(struct node *node, char *name, char *label);
> +struct node *name_node(struct node *node, char *name);
>  struct node *chain_node(struct node *first, struct node *list);
> +struct node *merge_nodes(struct node *old_node, struct node *new_node);
>  
>  void add_property(struct node *node, struct property *prop);
>  void add_child(struct node *parent, struct node *child);
> @@ -186,6 +182,10 @@ void add_child(struct node *parent, struct node *child);
>  const char *get_unitname(struct node *node);
>  struct property *get_property(struct node *node, const char *propname);
>  cell_t propval_cell(struct property *prop);
> +struct property *get_property_by_label(struct node *tree, const char *label,
> +				       struct node **node);
> +struct marker *get_marker_label(struct node *tree, const char *label,
> +				struct node **node, struct property **prop);
>  struct node *get_subnode(struct node *node, const char *nodename);
>  struct node *get_node_by_path(struct node *tree, const char *path);
>  struct node *get_node_by_label(struct node *tree, const char *label);
> @@ -193,6 +193,8 @@ struct node *get_node_by_phandle(struct node *tree, cell_t phandle);
>  struct node *get_node_by_ref(struct node *tree, const char *ref);
>  cell_t get_node_phandle(struct node *root, struct node *node);
>  
> +uint32_t guess_boot_cpuid(struct node *tree);
> +
>  /* Boot info (tree plus memreserve information */
>  
>  struct reserve_info {
> @@ -200,10 +202,10 @@ struct reserve_info {
>  
>  	struct reserve_info *next;
>  
> -	char *label;
> +	struct label *labels;
>  };
>  
> -struct reserve_info *build_reserve_entry(uint64_t start, uint64_t len, char *label);
> +struct reserve_info *build_reserve_entry(uint64_t start, uint64_t len);
>  struct reserve_info *chain_reserve_entry(struct reserve_info *first,
>  					 struct reserve_info *list);
>  struct reserve_info *add_reserve_entry(struct reserve_info *list,
> @@ -218,6 +220,7 @@ struct boot_info {
>  
>  struct boot_info *build_boot_info(struct reserve_info *reservelist,
>  				  struct node *tree, uint32_t boot_cpuid_phys);
> +void sort_tree(struct boot_info *bi);
>  
>  /* Checks */
>  
> @@ -239,8 +242,4 @@ struct boot_info *dt_from_source(const char *f);
>  
>  struct boot_info *dt_from_fs(const char *dirname);
>  
> -/* misc */
> -
> -char *join_path(const char *path, const char *name);
> -
>  #endif /* _DTC_H */
> diff --git a/scripts/dtc/flattree.c b/scripts/dtc/flattree.c
> index 76acd28..ead0332 100644
> --- a/scripts/dtc/flattree.c
> +++ b/scripts/dtc/flattree.c
> @@ -52,9 +52,9 @@ struct emitter {
>  	void (*string)(void *, char *, int);
>  	void (*align)(void *, int);
>  	void (*data)(void *, struct data);
> -	void (*beginnode)(void *, const char *);
> -	void (*endnode)(void *, const char *);
> -	void (*property)(void *, const char *);
> +	void (*beginnode)(void *, struct label *labels);
> +	void (*endnode)(void *, struct label *labels);
> +	void (*property)(void *, struct label *labels);
>  };
>  
>  static void bin_emit_cell(void *e, cell_t val)
> @@ -89,17 +89,17 @@ static void bin_emit_data(void *e, struct data d)
>  	*dtbuf = data_append_data(*dtbuf, d.val, d.len);
>  }
>  
> -static void bin_emit_beginnode(void *e, const char *label)
> +static void bin_emit_beginnode(void *e, struct label *labels)
>  {
>  	bin_emit_cell(e, FDT_BEGIN_NODE);
>  }
>  
> -static void bin_emit_endnode(void *e, const char *label)
> +static void bin_emit_endnode(void *e, struct label *labels)
>  {
>  	bin_emit_cell(e, FDT_END_NODE);
>  }
>  
> -static void bin_emit_property(void *e, const char *label)
> +static void bin_emit_property(void *e, struct label *labels)
>  {
>  	bin_emit_cell(e, FDT_PROP);
>  }
> @@ -127,11 +127,21 @@ static void emit_offset_label(FILE *f, const char *label, int offset)
>  	fprintf(f, "%s\t= . + %d\n", label, offset);
>  }
>  
> +#define ASM_EMIT_BELONG(f, fmt, ...) \
> +	{ \
> +		fprintf((f), "\t.byte\t((" fmt ") >> 24) & 0xff\n", __VA_ARGS__); \
> +		fprintf((f), "\t.byte\t((" fmt ") >> 16) & 0xff\n", __VA_ARGS__); \
> +		fprintf((f), "\t.byte\t((" fmt ") >> 8) & 0xff\n", __VA_ARGS__); \
> +		fprintf((f), "\t.byte\t(" fmt ") & 0xff\n", __VA_ARGS__); \
> +	}
> +
>  static void asm_emit_cell(void *e, cell_t val)
>  {
>  	FILE *f = e;
>  
> -	fprintf(f, "\t.long\t0x%x\n", val);
> +	fprintf(f, "\t.byte 0x%02x; .byte 0x%02x; .byte 0x%02x; .byte 0x%02x\n",
> +		(val >> 24) & 0xff, (val >> 16) & 0xff,
> +		(val >> 8) & 0xff, val & 0xff);
>  }
>  
>  static void asm_emit_string(void *e, char *str, int len)
> @@ -156,7 +166,7 @@ static void asm_emit_align(void *e, int a)
>  {
>  	FILE *f = e;
>  
> -	fprintf(f, "\t.balign\t%d\n", a);
> +	fprintf(f, "\t.balign\t%d, 0\n", a);
>  }
>  
>  static void asm_emit_data(void *e, struct data d)
> @@ -169,8 +179,7 @@ static void asm_emit_data(void *e, struct data d)
>  		emit_offset_label(f, m->ref, m->offset);
>  
>  	while ((d.len - off) >= sizeof(uint32_t)) {
> -		fprintf(f, "\t.long\t0x%x\n",
> -			fdt32_to_cpu(*((uint32_t *)(d.val+off))));
> +		asm_emit_cell(e, fdt32_to_cpu(*((uint32_t *)(d.val+off))));
>  		off += sizeof(uint32_t);
>  	}
>  
> @@ -182,37 +191,43 @@ static void asm_emit_data(void *e, struct data d)
>  	assert(off == d.len);
>  }
>  
> -static void asm_emit_beginnode(void *e, const char *label)
> +static void asm_emit_beginnode(void *e, struct label *labels)
>  {
>  	FILE *f = e;
> +	struct label *l;
>  
> -	if (label) {
> -		fprintf(f, "\t.globl\t%s\n", label);
> -		fprintf(f, "%s:\n", label);
> +	for_each_label(labels, l) {
> +		fprintf(f, "\t.globl\t%s\n", l->label);
> +		fprintf(f, "%s:\n", l->label);
>  	}
> -	fprintf(f, "\t.long\tFDT_BEGIN_NODE\n");
> +	fprintf(f, "\t/* FDT_BEGIN_NODE */\n");
> +	asm_emit_cell(e, FDT_BEGIN_NODE);
>  }
>  
> -static void asm_emit_endnode(void *e, const char *label)
> +static void asm_emit_endnode(void *e, struct label *labels)
>  {
>  	FILE *f = e;
> +	struct label *l;
>  
> -	fprintf(f, "\t.long\tFDT_END_NODE\n");
> -	if (label) {
> -		fprintf(f, "\t.globl\t%s_end\n", label);
> -		fprintf(f, "%s_end:\n", label);
> +	fprintf(f, "\t/* FDT_END_NODE */\n");
> +	asm_emit_cell(e, FDT_END_NODE);
> +	for_each_label(labels, l) {
> +		fprintf(f, "\t.globl\t%s_end\n", l->label);
> +		fprintf(f, "%s_end:\n", l->label);
>  	}
>  }
>  
> -static void asm_emit_property(void *e, const char *label)
> +static void asm_emit_property(void *e, struct label *labels)
>  {
>  	FILE *f = e;
> +	struct label *l;
>  
> -	if (label) {
> -		fprintf(f, "\t.globl\t%s\n", label);
> -		fprintf(f, "%s:\n", label);
> +	for_each_label(labels, l) {
> +		fprintf(f, "\t.globl\t%s\n", l->label);
> +		fprintf(f, "%s:\n", l->label);
>  	}
> -	fprintf(f, "\t.long\tFDT_PROP\n");
> +	fprintf(f, "\t/* FDT_PROP */\n");
> +	asm_emit_cell(e, FDT_PROP);
>  }
>  
>  static struct emitter asm_emitter = {
> @@ -248,7 +263,7 @@ static void flatten_tree(struct node *tree, struct emitter *emit,
>  	struct node *child;
>  	int seen_name_prop = 0;
>  
> -	emit->beginnode(etarget, tree->label);
> +	emit->beginnode(etarget, tree->labels);
>  
>  	if (vi->flags & FTF_FULLPATH)
>  		emit->string(etarget, tree->fullpath, 0);
> @@ -265,7 +280,7 @@ static void flatten_tree(struct node *tree, struct emitter *emit,
>  
>  		nameoff = stringtable_insert(strbuf, prop->name);
>  
> -		emit->property(etarget, prop->label);
> +		emit->property(etarget, prop->labels);
>  		emit->cell(etarget, prop->val.len);
>  		emit->cell(etarget, nameoff);
>  
> @@ -292,7 +307,7 @@ static void flatten_tree(struct node *tree, struct emitter *emit,
>  		flatten_tree(child, emit, etarget, strbuf, vi);
>  	}
>  
> -	emit->endnode(etarget, tree->label);
> +	emit->endnode(etarget, tree->labels);
>  }
>  
>  static struct data flatten_reserve_list(struct reserve_info *reservelist,
> @@ -413,10 +428,13 @@ void dt_to_blob(FILE *f, struct boot_info *bi, int version)
>  	if (padlen > 0)
>  		blob = data_append_zeroes(blob, padlen);
>  
> -	fwrite(blob.val, blob.len, 1, f);
> -
> -	if (ferror(f))
> -		die("Error writing device tree blob: %s\n", strerror(errno));
> +	if (fwrite(blob.val, blob.len, 1, f) != 1) {
> +		if (ferror(f))
> +			die("Error writing device tree blob: %s\n",
> +			    strerror(errno));
> +		else
> +			die("Short write on device tree blob\n");
> +	}
>  
>  	/*
>  	 * data_merge() frees the right-hand element so only the blob
> @@ -455,39 +473,44 @@ void dt_to_asm(FILE *f, struct boot_info *bi, int version)
>  		die("Unknown device tree blob version %d\n", version);
>  
>  	fprintf(f, "/* autogenerated by dtc, do not edit */\n\n");
> -	fprintf(f, "#define FDT_MAGIC 0x%x\n", FDT_MAGIC);
> -	fprintf(f, "#define FDT_BEGIN_NODE 0x%x\n", FDT_BEGIN_NODE);
> -	fprintf(f, "#define FDT_END_NODE 0x%x\n", FDT_END_NODE);
> -	fprintf(f, "#define FDT_PROP 0x%x\n", FDT_PROP);
> -	fprintf(f, "#define FDT_END 0x%x\n", FDT_END);
> -	fprintf(f, "\n");
>  
>  	emit_label(f, symprefix, "blob_start");
>  	emit_label(f, symprefix, "header");
> -	fprintf(f, "\t.long\tFDT_MAGIC\t\t\t\t/* magic */\n");
> -	fprintf(f, "\t.long\t_%s_blob_abs_end - _%s_blob_start\t/* totalsize */\n",
> -		symprefix, symprefix);
> -	fprintf(f, "\t.long\t_%s_struct_start - _%s_blob_start\t/* off_dt_struct */\n",
> +	fprintf(f, "\t/* magic */\n");
> +	asm_emit_cell(f, FDT_MAGIC);
> +	fprintf(f, "\t/* totalsize */\n");
> +	ASM_EMIT_BELONG(f, "_%s_blob_abs_end - _%s_blob_start",
> +			symprefix, symprefix);
> +	fprintf(f, "\t/* off_dt_struct */\n");
> +	ASM_EMIT_BELONG(f, "_%s_struct_start - _%s_blob_start",
>  		symprefix, symprefix);
> -	fprintf(f, "\t.long\t_%s_strings_start - _%s_blob_start\t/* off_dt_strings */\n",
> +	fprintf(f, "\t/* off_dt_strings */\n");
> +	ASM_EMIT_BELONG(f, "_%s_strings_start - _%s_blob_start",
>  		symprefix, symprefix);
> -	fprintf(f, "\t.long\t_%s_reserve_map - _%s_blob_start\t/* off_dt_strings */\n",
> +	fprintf(f, "\t/* off_mem_rsvmap */\n");
> +	ASM_EMIT_BELONG(f, "_%s_reserve_map - _%s_blob_start",
>  		symprefix, symprefix);
> -	fprintf(f, "\t.long\t%d\t\t\t\t\t/* version */\n", vi->version);
> -	fprintf(f, "\t.long\t%d\t\t\t\t\t/* last_comp_version */\n",
> -		vi->last_comp_version);
> -
> -	if (vi->flags & FTF_BOOTCPUID)
> -		fprintf(f, "\t.long\t%i\t\t\t\t\t/* boot_cpuid_phys */\n",
> -			bi->boot_cpuid_phys);
> +	fprintf(f, "\t/* version */\n");
> +	asm_emit_cell(f, vi->version);
> +	fprintf(f, "\t/* last_comp_version */\n");
> +	asm_emit_cell(f, vi->last_comp_version);
> +
> +	if (vi->flags & FTF_BOOTCPUID) {
> +		fprintf(f, "\t/* boot_cpuid_phys */\n");
> +		asm_emit_cell(f, bi->boot_cpuid_phys);
> +	}
>  
> -	if (vi->flags & FTF_STRTABSIZE)
> -		fprintf(f, "\t.long\t_%s_strings_end - _%s_strings_start\t/* size_dt_strings */\n",
> -			symprefix, symprefix);
> +	if (vi->flags & FTF_STRTABSIZE) {
> +		fprintf(f, "\t/* size_dt_strings */\n");
> +		ASM_EMIT_BELONG(f, "_%s_strings_end - _%s_strings_start",
> +				symprefix, symprefix);
> +	}
>  
> -	if (vi->flags & FTF_STRUCTSIZE)
> -		fprintf(f, "\t.long\t_%s_struct_end - _%s_struct_start\t/* size_dt_struct */\n",
> +	if (vi->flags & FTF_STRUCTSIZE) {
> +		fprintf(f, "\t/* size_dt_struct */\n");
> +		ASM_EMIT_BELONG(f, "_%s_struct_end - _%s_struct_start",
>  			symprefix, symprefix);
> +	}
>  
>  	/*
>  	 * Reserve map entries.
> @@ -505,16 +528,17 @@ void dt_to_asm(FILE *f, struct boot_info *bi, int version)
>  	 * as it appears .quad isn't available in some assemblers.
>  	 */
>  	for (re = bi->reservelist; re; re = re->next) {
> -		if (re->label) {
> -			fprintf(f, "\t.globl\t%s\n", re->label);
> -			fprintf(f, "%s:\n", re->label);
> +		struct label *l;
> +
> +		for_each_label(re->labels, l) {
> +			fprintf(f, "\t.globl\t%s\n", l->label);
> +			fprintf(f, "%s:\n", l->label);
>  		}
> -		fprintf(f, "\t.long\t0x%08x, 0x%08x\n",
> -			(unsigned int)(re->re.address >> 32),
> -			(unsigned int)(re->re.address & 0xffffffff));
> -		fprintf(f, "\t.long\t0x%08x, 0x%08x\n",
> -			(unsigned int)(re->re.size >> 32),
> -			(unsigned int)(re->re.size & 0xffffffff));
> +		ASM_EMIT_BELONG(f, "0x%08x", (unsigned int)(re->re.address >> 32));
> +		ASM_EMIT_BELONG(f, "0x%08x",
> +				(unsigned int)(re->re.address & 0xffffffff));
> +		ASM_EMIT_BELONG(f, "0x%08x", (unsigned int)(re->re.size >> 32));
> +		ASM_EMIT_BELONG(f, "0x%08x", (unsigned int)(re->re.size & 0xffffffff));
>  	}
>  	for (i = 0; i < reservenum; i++) {
>  		fprintf(f, "\t.long\t0, 0\n\t.long\t0, 0\n");
> @@ -524,7 +548,9 @@ void dt_to_asm(FILE *f, struct boot_info *bi, int version)
>  
>  	emit_label(f, symprefix, "struct_start");
>  	flatten_tree(bi->dt, &asm_emitter, f, &strbuf, vi);
> -	fprintf(f, "\t.long\tFDT_END\n");
> +
> +	fprintf(f, "\t/* FDT_END */\n");
> +	asm_emit_cell(f, FDT_END);
>  	emit_label(f, symprefix, "struct_end");
>  
>  	emit_label(f, symprefix, "strings_start");
> @@ -601,7 +627,7 @@ static char *flat_read_string(struct inbuf *inb)
>  		len++;
>  	} while ((*p++) != '\0');
>  
> -	str = strdup(inb->ptr);
> +	str = xstrdup(inb->ptr);
>  
>  	inb->ptr += len;
>  
> @@ -643,7 +669,7 @@ static char *flat_read_stringtable(struct inbuf *inb, int offset)
>  		p++;
>  	}
>  
> -	return strdup(inb->base + offset);
> +	return xstrdup(inb->base + offset);
>  }
>  
>  static struct property *flat_read_property(struct inbuf *dtbuf,
> @@ -663,7 +689,7 @@ static struct property *flat_read_property(struct inbuf *dtbuf,
>  
>  	val = flat_read_data(dtbuf, proplen);
>  
> -	return build_property(name, val, NULL);
> +	return build_property(name, val);
>  }
>  
>  
> @@ -688,7 +714,7 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
>  		if (re.size == 0)
>  			break;
>  
> -		new = build_reserve_entry(re.address, re.size, NULL);
> +		new = build_reserve_entry(re.address, re.size);
>  		reservelist = add_reserve_entry(reservelist, new);
>  	}
>  
> @@ -710,7 +736,7 @@ static char *nodename_from_path(const char *ppath, const char *cpath)
>  	if (!streq(ppath, "/"))
>  		plen++;
>  
> -	return strdup(cpath + plen);
> +	return xstrdup(cpath + plen);
>  }
>  
>  static struct node *unflatten_tree(struct inbuf *dtbuf,
> @@ -776,7 +802,7 @@ static struct node *unflatten_tree(struct inbuf *dtbuf,
>  
>  struct boot_info *dt_from_blob(const char *fname)
>  {
> -	struct dtc_file *dtcf;
> +	FILE *f;
>  	uint32_t magic, totalsize, version, size_dt, boot_cpuid_phys;
>  	uint32_t off_dt, off_str, off_mem_rsvmap;
>  	int rc;
> @@ -791,14 +817,14 @@ struct boot_info *dt_from_blob(const char *fname)
>  	uint32_t val;
>  	int flags = 0;
>  
> -	dtcf = dtc_open_file(fname, NULL);
> +	f = srcfile_relative_open(fname, NULL);
>  
> -	rc = fread(&magic, sizeof(magic), 1, dtcf->file);
> -	if (ferror(dtcf->file))
> +	rc = fread(&magic, sizeof(magic), 1, f);
> +	if (ferror(f))
>  		die("Error reading DT blob magic number: %s\n",
>  		    strerror(errno));
>  	if (rc < 1) {
> -		if (feof(dtcf->file))
> +		if (feof(f))
>  			die("EOF reading DT blob magic number\n");
>  		else
>  			die("Mysterious short read reading magic number\n");
> @@ -808,11 +834,11 @@ struct boot_info *dt_from_blob(const char *fname)
>  	if (magic != FDT_MAGIC)
>  		die("Blob has incorrect magic number\n");
>  
> -	rc = fread(&totalsize, sizeof(totalsize), 1, dtcf->file);
> -	if (ferror(dtcf->file))
> +	rc = fread(&totalsize, sizeof(totalsize), 1, f);
> +	if (ferror(f))
>  		die("Error reading DT blob size: %s\n", strerror(errno));
>  	if (rc < 1) {
> -		if (feof(dtcf->file))
> +		if (feof(f))
>  			die("EOF reading DT blob size\n");
>  		else
>  			die("Mysterious short read reading blob size\n");
> @@ -832,12 +858,12 @@ struct boot_info *dt_from_blob(const char *fname)
>  	p = blob + sizeof(magic)  + sizeof(totalsize);
>  
>  	while (sizeleft) {
> -		if (feof(dtcf->file))
> +		if (feof(f))
>  			die("EOF before reading %d bytes of DT blob\n",
>  			    totalsize);
>  
> -		rc = fread(p, 1, sizeleft, dtcf->file);
> -		if (ferror(dtcf->file))
> +		rc = fread(p, 1, sizeleft, f);
> +		if (ferror(f))
>  			die("Error reading DT blob: %s\n",
>  			    strerror(errno));
>  
> @@ -900,7 +926,7 @@ struct boot_info *dt_from_blob(const char *fname)
>  
>  	free(blob);
>  
> -	dtc_close_file(dtcf);
> +	fclose(f);
>  
>  	return build_boot_info(reservelist, tree, boot_cpuid_phys);
>  }
> diff --git a/scripts/dtc/fstree.c b/scripts/dtc/fstree.c
> index 8fe1bdf..f377453 100644
> --- a/scripts/dtc/fstree.c
> +++ b/scripts/dtc/fstree.c
> @@ -58,10 +58,9 @@ static struct node *read_fstree(const char *dirname)
>  					"WARNING: Cannot open %s: %s\n",
>  					tmpnam, strerror(errno));
>  			} else {
> -				prop = build_property(strdup(de->d_name),
> +				prop = build_property(xstrdup(de->d_name),
>  						      data_copy_file(pfile,
> -								     st.st_size),
> -						      NULL);
> +								     st.st_size));
>  				add_property(tree, prop);
>  				fclose(pfile);
>  			}
> @@ -69,8 +68,7 @@ static struct node *read_fstree(const char *dirname)
>  			struct node *newchild;
>  
>  			newchild = read_fstree(tmpnam);
> -			newchild = name_node(newchild, strdup(de->d_name),
> -					     NULL);
> +			newchild = name_node(newchild, xstrdup(de->d_name));
>  			add_child(tree, newchild);
>  		}
>  
> @@ -86,8 +84,8 @@ struct boot_info *dt_from_fs(const char *dirname)
>  	struct node *tree;
>  
>  	tree = read_fstree(dirname);
> -	tree = name_node(tree, "", NULL);
> +	tree = name_node(tree, "");
>  
> -	return build_boot_info(NULL, tree, 0);
> +	return build_boot_info(NULL, tree, guess_boot_cpuid(tree));
>  }
>  
> diff --git a/scripts/dtc/livetree.c b/scripts/dtc/livetree.c
> index 0ca3de5..c9209d5 100644
> --- a/scripts/dtc/livetree.c
> +++ b/scripts/dtc/livetree.c
> @@ -24,17 +24,30 @@
>   * Tree building functions
>   */
>  
> -struct property *build_property(char *name, struct data val, char *label)
> +void add_label(struct label **labels, char *label)
> +{
> +	struct label *new;
> +
> +	/* Make sure the label isn't already there */
> +	for_each_label(*labels, new)
> +		if (streq(new->label, label))
> +			return;
> +
> +	new = xmalloc(sizeof(*new));
> +	new->label = label;
> +	new->next = *labels;
> +	*labels = new;
> +}
> +
> +struct property *build_property(char *name, struct data val)
>  {
>  	struct property *new = xmalloc(sizeof(*new));
>  
> +	memset(new, 0, sizeof(*new));
> +
>  	new->name = name;
>  	new->val = val;
>  
> -	new->next = NULL;
> -
> -	new->label = label;
> -
>  	return new;
>  }
>  
> @@ -78,17 +91,82 @@ struct node *build_node(struct property *proplist, struct node *children)
>  	return new;
>  }
>  
> -struct node *name_node(struct node *node, char *name, char * label)
> +struct node *name_node(struct node *node, char *name)
>  {
>  	assert(node->name == NULL);
>  
>  	node->name = name;
>  
> -	node->label = label;
> -
>  	return node;
>  }
>  
> +struct node *merge_nodes(struct node *old_node, struct node *new_node)
> +{
> +	struct property *new_prop, *old_prop;
> +	struct node *new_child, *old_child;
> +	struct label *l;
> +
> +	/* Add new node labels to old node */
> +	for_each_label(new_node->labels, l)
> +		add_label(&old_node->labels, l->label);
> +
> +	/* Move properties from the new node to the old node.  If there
> +	 * is a collision, replace the old value with the new */
> +	while (new_node->proplist) {
> +		/* Pop the property off the list */
> +		new_prop = new_node->proplist;
> +		new_node->proplist = new_prop->next;
> +		new_prop->next = NULL;
> +
> +		/* Look for a collision, set new value if there is */
> +		for_each_property(old_node, old_prop) {
> +			if (streq(old_prop->name, new_prop->name)) {
> +				/* Add new labels to old property */
> +				for_each_label(new_prop->labels, l)
> +					add_label(&old_prop->labels, l->label);
> +
> +				old_prop->val = new_prop->val;
> +				free(new_prop);
> +				new_prop = NULL;
> +				break;
> +			}
> +		}
> +
> +		/* if no collision occurred, add property to the old node. */
> +		if (new_prop)
> +			add_property(old_node, new_prop);
> +	}
> +
> +	/* Move the override child nodes into the primary node.  If
> +	 * there is a collision, then merge the nodes. */
> +	while (new_node->children) {
> +		/* Pop the child node off the list */
> +		new_child = new_node->children;
> +		new_node->children = new_child->next_sibling;
> +		new_child->parent = NULL;
> +		new_child->next_sibling = NULL;
> +
> +		/* Search for a collision.  Merge if there is */
> +		for_each_child(old_node, old_child) {
> +			if (streq(old_child->name, new_child->name)) {
> +				merge_nodes(old_child, new_child);
> +				new_child = NULL;
> +				break;
> +			}
> +		}
> +
> +		/* if no collision occured, add child to the old node. */
> +		if (new_child)
> +			add_child(old_node, new_child);
> +	}
> +
> +	/* The new node contents are now merged into the old node.  Free
> +	 * the new node. */
> +	free(new_node);
> +
> +	return old_node;
> +}
> +
>  struct node *chain_node(struct node *first, struct node *list)
>  {
>  	assert(first->next_sibling == NULL);
> @@ -124,18 +202,15 @@ void add_child(struct node *parent, struct node *child)
>  	*p = child;
>  }
>  
> -struct reserve_info *build_reserve_entry(uint64_t address, uint64_t size,
> -					 char *label)
> +struct reserve_info *build_reserve_entry(uint64_t address, uint64_t size)
>  {
>  	struct reserve_info *new = xmalloc(sizeof(*new));
>  
> +	memset(new, 0, sizeof(*new));
> +
>  	new->re.address = address;
>  	new->re.size = size;
>  
> -	new->next = NULL;
> -
> -	new->label = label;
> -
>  	return new;
>  }
>  
> @@ -208,6 +283,60 @@ cell_t propval_cell(struct property *prop)
>  	return fdt32_to_cpu(*((cell_t *)prop->val.val));
>  }
>  
> +struct property *get_property_by_label(struct node *tree, const char *label,
> +				       struct node **node)
> +{
> +	struct property *prop;
> +	struct node *c;
> +
> +	*node = tree;
> +
> +	for_each_property(tree, prop) {
> +		struct label *l;
> +
> +		for_each_label(prop->labels, l)
> +			if (streq(l->label, label))
> +				return prop;
> +	}
> +
> +	for_each_child(tree, c) {
> +		prop = get_property_by_label(c, label, node);
> +		if (prop)
> +			return prop;
> +	}
> +
> +	*node = NULL;
> +	return NULL;
> +}
> +
> +struct marker *get_marker_label(struct node *tree, const char *label,
> +				struct node **node, struct property **prop)
> +{
> +	struct marker *m;
> +	struct property *p;
> +	struct node *c;
> +
> +	*node = tree;
> +
> +	for_each_property(tree, p) {
> +		*prop = p;
> +		m = p->val.markers;
> +		for_each_marker_of_type(m, LABEL)
> +			if (streq(m->ref, label))
> +				return m;
> +	}
> +
> +	for_each_child(tree, c) {
> +		m = get_marker_label(c, label, node, prop);
> +		if (m)
> +			return m;
> +	}
> +
> +	*prop = NULL;
> +	*node = NULL;
> +	return NULL;
> +}
> +
>  struct node *get_subnode(struct node *node, const char *nodename)
>  {
>  	struct node *child;
> @@ -245,11 +374,13 @@ struct node *get_node_by_path(struct node *tree, const char *path)
>  struct node *get_node_by_label(struct node *tree, const char *label)
>  {
>  	struct node *child, *node;
> +	struct label *l;
>  
>  	assert(label && (strlen(label) > 0));
>  
> -	if (tree->label && streq(tree->label, label))
> -		return tree;
> +	for_each_label(tree->labels, l)
> +		if (streq(l->label, label))
> +			return tree;
>  
>  	for_each_child(tree, child) {
>  		node = get_node_by_label(child, label);
> @@ -293,16 +424,186 @@ cell_t get_node_phandle(struct node *root, struct node *node)
>  	if ((node->phandle != 0) && (node->phandle != -1))
>  		return node->phandle;
>  
> -	assert(! get_property(node, "linux,phandle"));
> -
>  	while (get_node_by_phandle(root, phandle))
>  		phandle++;
>  
>  	node->phandle = phandle;
> -	add_property(node,
> -		     build_property("linux,phandle",
> -				    data_append_cell(empty_data, phandle),
> -				    NULL));
> +
> +	if (!get_property(node, "linux,phandle")
> +	    && (phandle_format & PHANDLE_LEGACY))
> +		add_property(node,
> +			     build_property("linux,phandle",
> +					    data_append_cell(empty_data, phandle)));
> +
> +	if (!get_property(node, "phandle")
> +	    && (phandle_format & PHANDLE_EPAPR))
> +		add_property(node,
> +			     build_property("phandle",
> +					    data_append_cell(empty_data, phandle)));
> +
> +	/* If the node *does* have a phandle property, we must
> +	 * be dealing with a self-referencing phandle, which will be
> +	 * fixed up momentarily in the caller */
>  
>  	return node->phandle;
>  }
> +
> +uint32_t guess_boot_cpuid(struct node *tree)
> +{
> +	struct node *cpus, *bootcpu;
> +	struct property *reg;
> +
> +	cpus = get_node_by_path(tree, "/cpus");
> +	if (!cpus)
> +		return 0;
> +
> +
> +	bootcpu = cpus->children;
> +	if (!bootcpu)
> +		return 0;
> +
> +	reg = get_property(bootcpu, "reg");
> +	if (!reg || (reg->val.len != sizeof(uint32_t)))
> +		return 0;
> +
> +	/* FIXME: Sanity check node? */
> +
> +	return propval_cell(reg);
> +}
> +
> +static int cmp_reserve_info(const void *ax, const void *bx)
> +{
> +	const struct reserve_info *a, *b;
> +
> +	a = *((const struct reserve_info * const *)ax);
> +	b = *((const struct reserve_info * const *)bx);
> +
> +	if (a->re.address < b->re.address)
> +		return -1;
> +	else if (a->re.address > b->re.address)
> +		return 1;
> +	else if (a->re.size < b->re.size)
> +		return -1;
> +	else if (a->re.size > b->re.size)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static void sort_reserve_entries(struct boot_info *bi)
> +{
> +	struct reserve_info *ri, **tbl;
> +	int n = 0, i = 0;
> +
> +	for (ri = bi->reservelist;
> +	     ri;
> +	     ri = ri->next)
> +		n++;
> +
> +	if (n == 0)
> +		return;
> +
> +	tbl = xmalloc(n * sizeof(*tbl));
> +
> +	for (ri = bi->reservelist;
> +	     ri;
> +	     ri = ri->next)
> +		tbl[i++] = ri;
> +
> +	qsort(tbl, n, sizeof(*tbl), cmp_reserve_info);
> +
> +	bi->reservelist = tbl[0];
> +	for (i = 0; i < (n-1); i++)
> +		tbl[i]->next = tbl[i+1];
> +	tbl[n-1]->next = NULL;
> +
> +	free(tbl);
> +}
> +
> +static int cmp_prop(const void *ax, const void *bx)
> +{
> +	const struct property *a, *b;
> +
> +	a = *((const struct property * const *)ax);
> +	b = *((const struct property * const *)bx);
> +
> +	return strcmp(a->name, b->name);
> +}
> +
> +static void sort_properties(struct node *node)
> +{
> +	int n = 0, i = 0;
> +	struct property *prop, **tbl;
> +
> +	for_each_property(node, prop)
> +		n++;
> +
> +	if (n == 0)
> +		return;
> +
> +	tbl = xmalloc(n * sizeof(*tbl));
> +
> +	for_each_property(node, prop)
> +		tbl[i++] = prop;
> +
> +	qsort(tbl, n, sizeof(*tbl), cmp_prop);
> +
> +	node->proplist = tbl[0];
> +	for (i = 0; i < (n-1); i++)
> +		tbl[i]->next = tbl[i+1];
> +	tbl[n-1]->next = NULL;
> +
> +	free(tbl);
> +}
> +
> +static int cmp_subnode(const void *ax, const void *bx)
> +{
> +	const struct node *a, *b;
> +
> +	a = *((const struct node * const *)ax);
> +	b = *((const struct node * const *)bx);
> +
> +	return strcmp(a->name, b->name);
> +}
> +
> +static void sort_subnodes(struct node *node)
> +{
> +	int n = 0, i = 0;
> +	struct node *subnode, **tbl;
> +
> +	for_each_child(node, subnode)
> +		n++;
> +
> +	if (n == 0)
> +		return;
> +
> +	tbl = xmalloc(n * sizeof(*tbl));
> +
> +	for_each_child(node, subnode)
> +		tbl[i++] = subnode;
> +
> +	qsort(tbl, n, sizeof(*tbl), cmp_subnode);
> +
> +	node->children = tbl[0];
> +	for (i = 0; i < (n-1); i++)
> +		tbl[i]->next_sibling = tbl[i+1];
> +	tbl[n-1]->next_sibling = NULL;
> +
> +	free(tbl);
> +}
> +
> +static void sort_node(struct node *node)
> +{
> +	struct node *c;
> +
> +	sort_properties(node);
> +	sort_subnodes(node);
> +	for_each_child(node, c)
> +		sort_node(c);
> +}
> +
> +void sort_tree(struct boot_info *bi)
> +{
> +	sort_reserve_entries(bi);
> +	sort_node(bi->dt);
> +}
> diff --git a/scripts/dtc/srcpos.c b/scripts/dtc/srcpos.c
> index 9641b76..2dbc874 100644
> --- a/scripts/dtc/srcpos.c
> +++ b/scripts/dtc/srcpos.c
> @@ -17,100 +17,232 @@
>   *                                                                   USA
>   */
>  
> +#define _GNU_SOURCE
> +
> +#include <stdio.h>
> +
>  #include "dtc.h"
>  #include "srcpos.h"
>  
> -/*
> - * Like yylineno, this is the current open file pos.
> - */
>  
> -struct dtc_file *srcpos_file;
> +static char *dirname(const char *path)
> +{
> +	const char *slash = strrchr(path, '/');
> +
> +	if (slash) {
> +		int len = slash - path;
> +		char *dir = xmalloc(len + 1);
> +
> +		memcpy(dir, path, len);
> +		dir[len] = '\0';
> +		return dir;
> +	}
> +	return NULL;
> +}
> +
> +struct srcfile_state *current_srcfile; /* = NULL */
>  
> -static int dtc_open_one(struct dtc_file *file,
> -                        const char *search,
> -                        const char *fname)
> +/* Detect infinite include recursion. */
> +#define MAX_SRCFILE_DEPTH     (100)
> +static int srcfile_depth; /* = 0 */
> +
> +FILE *srcfile_relative_open(const char *fname, char **fullnamep)
>  {
> +	FILE *f;
>  	char *fullname;
>  
> -	if (search) {
> -		fullname = xmalloc(strlen(search) + strlen(fname) + 2);
> -
> -		strcpy(fullname, search);
> -		strcat(fullname, "/");
> -		strcat(fullname, fname);
> +	if (streq(fname, "-")) {
> +		f = stdin;
> +		fullname = xstrdup("<stdin>");
>  	} else {
> -		fullname = strdup(fname);
> +		if (!current_srcfile || !current_srcfile->dir
> +		    || (fname[0] == '/'))
> +			fullname = xstrdup(fname);
> +		else
> +			fullname = join_path(current_srcfile->dir, fname);
> +
> +		f = fopen(fullname, "r");
> +		if (!f)
> +			die("Couldn't open \"%s\": %s\n", fname,
> +			    strerror(errno));
>  	}
>  
> -	file->file = fopen(fullname, "r");
> -	if (!file->file) {
> +	if (fullnamep)
> +		*fullnamep = fullname;
> +	else
>  		free(fullname);
> -		return 0;
> -	}
>  
> -	file->name = fullname;
> -	return 1;
> +	return f;
>  }
>  
> +void srcfile_push(const char *fname)
> +{
> +	struct srcfile_state *srcfile;
> +
> +	if (srcfile_depth++ >= MAX_SRCFILE_DEPTH)
> +		die("Includes nested too deeply");
> +
> +	srcfile = xmalloc(sizeof(*srcfile));
> +
> +	srcfile->f = srcfile_relative_open(fname, &srcfile->name);
> +	srcfile->dir = dirname(srcfile->name);
> +	srcfile->prev = current_srcfile;
> +
> +	srcfile->lineno = 1;
> +	srcfile->colno = 1;
> +
> +	current_srcfile = srcfile;
> +}
>  
> -struct dtc_file *dtc_open_file(const char *fname,
> -                               const struct search_path *search)
> +int srcfile_pop(void)
>  {
> -	static const struct search_path default_search = { NULL, NULL, NULL };
> +	struct srcfile_state *srcfile = current_srcfile;
>  
> -	struct dtc_file *file;
> -	const char *slash;
> +	assert(srcfile);
>  
> -	file = xmalloc(sizeof(struct dtc_file));
> +	current_srcfile = srcfile->prev;
>  
> -	slash = strrchr(fname, '/');
> -	if (slash) {
> -		char *dir = xmalloc(slash - fname + 1);
> +	if (fclose(srcfile->f))
> +		die("Error closing \"%s\": %s\n", srcfile->name,
> +		    strerror(errno));
>  
> -		memcpy(dir, fname, slash - fname);
> -		dir[slash - fname] = 0;
> -		file->dir = dir;
> -	} else {
> -		file->dir = NULL;
> -	}
> +	/* FIXME: We allow the srcfile_state structure to leak,
> +	 * because it could still be referenced from a location
> +	 * variable being carried through the parser somewhere.  To
> +	 * fix this we could either allocate all the files from a
> +	 * table, or use a pool allocator. */
>  
> -	if (streq(fname, "-")) {
> -		file->name = "stdin";
> -		file->file = stdin;
> -		return file;
> -	}
> +	return current_srcfile ? 1 : 0;
> +}
>  
> -	if (fname[0] == '/') {
> -		file->file = fopen(fname, "r");
> -		if (!file->file)
> -			goto fail;
> +/*
> + * The empty source position.
> + */
>  
> -		file->name = strdup(fname);
> -		return file;
> -	}
> +struct srcpos srcpos_empty = {
> +	.first_line = 0,
> +	.first_column = 0,
> +	.last_line = 0,
> +	.last_column = 0,
> +	.file = NULL,
> +};
>  
> -	if (!search)
> -		search = &default_search;
> +#define TAB_SIZE      8
>  
> -	while (search) {
> -		if (dtc_open_one(file, search->dir, fname))
> -			return file;
> +void srcpos_update(struct srcpos *pos, const char *text, int len)
> +{
> +	int i;
> +
> +	pos->file = current_srcfile;
> +
> +	pos->first_line = current_srcfile->lineno;
> +	pos->first_column = current_srcfile->colno;
> +
> +	for (i = 0; i < len; i++)
> +		if (text[i] == '\n') {
> +			current_srcfile->lineno++;
> +			current_srcfile->colno = 1;
> +		} else if (text[i] == '\t') {
> +			current_srcfile->colno =
> +				ALIGN(current_srcfile->colno, TAB_SIZE);
> +		} else {
> +			current_srcfile->colno++;
> +		}
> +
> +	pos->last_line = current_srcfile->lineno;
> +	pos->last_column = current_srcfile->colno;
> +}
>  
> -		if (errno != ENOENT)
> -			goto fail;
> +struct srcpos *
> +srcpos_copy(struct srcpos *pos)
> +{
> +	struct srcpos *pos_new;
>  
> -		search = search->next;
> -	}
> +	pos_new = xmalloc(sizeof(struct srcpos));
> +	memcpy(pos_new, pos, sizeof(struct srcpos));
> +
> +	return pos_new;
> +}
> +
> +
> +
> +void
> +srcpos_dump(struct srcpos *pos)
> +{
> +	printf("file        : \"%s\"\n",
> +	       pos->file ? (char *) pos->file : "<no file>");
> +	printf("first_line  : %d\n", pos->first_line);
> +	printf("first_column: %d\n", pos->first_column);
> +	printf("last_line   : %d\n", pos->last_line);
> +	printf("last_column : %d\n", pos->last_column);
> +	printf("file        : %s\n", pos->file->name);
> +}
>  
> -fail:
> -	die("Couldn't open \"%s\": %s\n", fname, strerror(errno));
> +
> +char *
> +srcpos_string(struct srcpos *pos)
> +{
> +	const char *fname = "<no-file>";
> +	char *pos_str;
> +	int rc;
> +
> +	if (pos)
> +		fname = pos->file->name;
> +
> +
> +	if (pos->first_line != pos->last_line)
> +		rc = asprintf(&pos_str, "%s:%d.%d-%d.%d", fname,
> +			      pos->first_line, pos->first_column,
> +			      pos->last_line, pos->last_column);
> +	else if (pos->first_column != pos->last_column)
> +		rc = asprintf(&pos_str, "%s:%d.%d-%d", fname,
> +			      pos->first_line, pos->first_column,
> +			      pos->last_column);
> +	else
> +		rc = asprintf(&pos_str, "%s:%d.%d", fname,
> +			      pos->first_line, pos->first_column);
> +
> +	if (rc == -1)
> +		die("Couldn't allocate in srcpos string");
> +
> +	return pos_str;
> +}
> +
> +void
> +srcpos_verror(struct srcpos *pos, char const *fmt, va_list va)
> +{
> +       const char *srcstr;
> +
> +       srcstr = srcpos_string(pos);
> +
> +       fprintf(stdout, "Error: %s ", srcstr);
> +       vfprintf(stdout, fmt, va);
> +       fprintf(stdout, "\n");
>  }
>  
> -void dtc_close_file(struct dtc_file *file)
> +void
> +srcpos_error(struct srcpos *pos, char const *fmt, ...)
>  {
> -	if (fclose(file->file))
> -		die("Error closing \"%s\": %s\n", file->name, strerror(errno));
> +	va_list va;
> +
> +	va_start(va, fmt);
> +	srcpos_verror(pos, fmt, va);
> +	va_end(va);
> +}
> +
> +
> +void
> +srcpos_warn(struct srcpos *pos, char const *fmt, ...)
> +{
> +	const char *srcstr;
> +	va_list va;
> +	va_start(va, fmt);
> +
> +	srcstr = srcpos_string(pos);
> +
> +	fprintf(stderr, "Warning: %s ", srcstr);
> +	vfprintf(stderr, fmt, va);
> +	fprintf(stderr, "\n");
>  
> -	free(file->dir);
> -	free(file);
> +	va_end(va);
>  }
> diff --git a/scripts/dtc/srcpos.h b/scripts/dtc/srcpos.h
> index e17c7c0..bd7966e 100644
> --- a/scripts/dtc/srcpos.h
> +++ b/scripts/dtc/srcpos.h
> @@ -17,69 +17,70 @@
>   *                                                                   USA
>   */
>  
> -/*
> - * Augment the standard YYLTYPE with a filenum index into an
> - * array of all opened filenames.
> - */
> +#ifndef _SRCPOS_H_
> +#define _SRCPOS_H_
>  
>  #include <stdio.h>
>  
> -struct dtc_file {
> +struct srcfile_state {
> +	FILE *f;
> +	char *name;
>  	char *dir;
> -	const char *name;
> -	FILE *file;
> +	int lineno, colno;
> +	struct srcfile_state *prev;
>  };
>  
> -#if ! defined(YYLTYPE) && ! defined(YYLTYPE_IS_DECLARED)
> -typedef struct YYLTYPE {
> +extern struct srcfile_state *current_srcfile; /* = NULL */
> +
> +FILE *srcfile_relative_open(const char *fname, char **fullnamep);
> +void srcfile_push(const char *fname);
> +int srcfile_pop(void);
> +
> +struct srcpos {
>      int first_line;
>      int first_column;
>      int last_line;
>      int last_column;
> -    struct dtc_file *file;
> -} YYLTYPE;
> -
> -#define YYLTYPE_IS_DECLARED	1
> -#define YYLTYPE_IS_TRIVIAL	1
> -#endif
> -
> -/* Cater to old parser templates. */
> -#ifndef YYID
> -#define YYID(n)	(n)
> -#endif
> +    struct srcfile_state *file;
> +};
>  
> -#define YYLLOC_DEFAULT(Current, Rhs, N)					\
> -    do									\
> -      if (YYID (N))							\
> -	{								\
> -	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
> -	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
> -	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
> -	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
> -	  (Current).file         = YYRHSLOC (Rhs, N).file;		\
> -	}								\
> -      else								\
> -	{								\
> -	  (Current).first_line   = (Current).last_line   =		\
> -	    YYRHSLOC (Rhs, 0).last_line;				\
> -	  (Current).first_column = (Current).last_column =		\
> -	    YYRHSLOC (Rhs, 0).last_column;				\
> -	  (Current).file         = YYRHSLOC (Rhs, 0).file;		\
> -	}								\
> -    while (YYID (0))
> +#define YYLTYPE struct srcpos
>  
> +#define YYLLOC_DEFAULT(Current, Rhs, N)						\
> +	do {									\
> +		if (N) {							\
> +			(Current).first_line = YYRHSLOC(Rhs, 1).first_line;	\
> +			(Current).first_column = YYRHSLOC(Rhs, 1).first_column;	\
> +			(Current).last_line = YYRHSLOC(Rhs, N).last_line;	\
> +			(Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
> +			(Current).file = YYRHSLOC(Rhs, N).file;			\
> +		} else {							\
> +			(Current).first_line = (Current).last_line =		\
> +				YYRHSLOC(Rhs, 0).last_line;			\
> +			(Current).first_column = (Current).last_column =	\
> +				YYRHSLOC(Rhs, 0).last_column;			\
> +			(Current).file = YYRHSLOC (Rhs, 0).file;		\
> +		}								\
> +	} while (0)
>  
>  
> -extern void yyerror(char const *);
> -extern void yyerrorf(char const *, ...) __attribute__((format(printf, 1, 2)));
> +/*
> + * Fictional source position used for IR nodes that are
> + * created without otherwise knowing a true source position.
> + * For example,constant definitions from the command line.
> + */
> +extern struct srcpos srcpos_empty;
>  
> -extern struct dtc_file *srcpos_file;
> +extern void srcpos_update(struct srcpos *pos, const char *text, int len);
> +extern struct srcpos *srcpos_copy(struct srcpos *pos);
> +extern char *srcpos_string(struct srcpos *pos);
> +extern void srcpos_dump(struct srcpos *pos);
>  
> -struct search_path {
> -	const char *dir; /* NULL for current directory */
> -	struct search_path *prev, *next;
> -};
> +extern void srcpos_verror(struct srcpos *pos, char const *, va_list va)
> +     __attribute__((format(printf, 2, 0)));
> +extern void srcpos_error(struct srcpos *pos, char const *, ...)
> +     __attribute__((format(printf, 2, 3)));
> +extern void srcpos_warn(struct srcpos *pos, char const *, ...)
> +     __attribute__((format(printf, 2, 3)));
>  
> -extern struct dtc_file *dtc_open_file(const char *fname,
> -                                      const struct search_path *search);
> -extern void dtc_close_file(struct dtc_file *file);
> +#endif /* _SRCPOS_H_ */
> diff --git a/scripts/dtc/treesource.c b/scripts/dtc/treesource.c
> index 1521ff1..c09aafa 100644
> --- a/scripts/dtc/treesource.c
> +++ b/scripts/dtc/treesource.c
> @@ -32,8 +32,8 @@ struct boot_info *dt_from_source(const char *fname)
>  	the_boot_info = NULL;
>  	treesource_error = 0;
>  
> -	srcpos_file = dtc_open_file(fname, NULL);
> -	yyin = srcpos_file->file;
> +	srcfile_push(fname);
> +	yyin = current_srcfile->f;
>  
>  	if (yyparse() != 0)
>  		die("Unable to parse input tree\n");
> @@ -63,26 +63,20 @@ static void write_propval_string(FILE *f, struct data val)
>  {
>  	const char *str = val.val;
>  	int i;
> -	int newchunk = 1;
>  	struct marker *m = val.markers;
>  
>  	assert(str[val.len-1] == '\0');
>  
> +	while (m && (m->offset == 0)) {
> +		if (m->type == LABEL)
> +			fprintf(f, "%s: ", m->ref);
> +		m = m->next;
> +	}
> +	fprintf(f, "\"");
> +
>  	for (i = 0; i < (val.len-1); i++) {
>  		char c = str[i];
>  
> -		if (newchunk) {
> -			while (m && (m->offset <= i)) {
> -				if (m->type == LABEL) {
> -					assert(m->offset == i);
> -					fprintf(f, "%s: ", m->ref);
> -				}
> -				m = m->next;
> -			}
> -			fprintf(f, "\"");
> -			newchunk = 0;
> -		}
> -
>  		switch (c) {
>  		case '\a':
>  			fprintf(f, "\\a");
> @@ -113,7 +107,14 @@ static void write_propval_string(FILE *f, struct data val)
>  			break;
>  		case '\0':
>  			fprintf(f, "\", ");
> -			newchunk = 1;
> +			while (m && (m->offset < i)) {
> +				if (m->type == LABEL) {
> +					assert(m->offset == (i+1));
> +					fprintf(f, "%s: ", m->ref);
> +				}
> +				m = m->next;
> +			}
> +			fprintf(f, "\"");
>  			break;
>  		default:
>  			if (isprint(c))
> @@ -234,10 +235,11 @@ static void write_tree_source_node(FILE *f, struct node *tree, int level)
>  {
>  	struct property *prop;
>  	struct node *child;
> +	struct label *l;
>  
>  	write_prefix(f, level);
> -	if (tree->label)
> -		fprintf(f, "%s: ", tree->label);
> +	for_each_label(tree->labels, l)
> +		fprintf(f, "%s: ", l->label);
>  	if (tree->name && (*tree->name))
>  		fprintf(f, "%s {\n", tree->name);
>  	else
> @@ -245,8 +247,8 @@ static void write_tree_source_node(FILE *f, struct node *tree, int level)
>  
>  	for_each_property(tree, prop) {
>  		write_prefix(f, level+1);
> -		if (prop->label)
> -			fprintf(f, "%s: ", prop->label);
> +		for_each_label(prop->labels, l)
> +			fprintf(f, "%s: ", l->label);
>  		fprintf(f, "%s", prop->name);
>  		write_propval(f, prop);
>  	}
> @@ -266,8 +268,10 @@ void dt_to_source(FILE *f, struct boot_info *bi)
>  	fprintf(f, "/dts-v1/;\n\n");
>  
>  	for (re = bi->reservelist; re; re = re->next) {
> -		if (re->label)
> -			fprintf(f, "%s: ", re->label);
> +		struct label *l;
> +
> +		for_each_label(re->labels, l)
> +			fprintf(f, "%s: ", l->label);
>  		fprintf(f, "/memreserve/\t0x%016llx 0x%016llx;\n",
>  			(unsigned long long)re->re.address,
>  			(unsigned long long)re->re.size);
> diff --git a/scripts/dtc/version_gen.h b/scripts/dtc/version_gen.h
> index 658ff42..0c35fb2 100644
> --- a/scripts/dtc/version_gen.h
> +++ b/scripts/dtc/version_gen.h
> @@ -1 +1 @@
> -#define DTC_VERSION "DTC 1.2.0"
> +#define DTC_VERSION "DTC 1.2.0-g211e80d4"
> 
