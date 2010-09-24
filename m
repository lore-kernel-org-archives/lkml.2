Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab0IXQuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:50:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64467 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab0IXQu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Tmi7cCW6TfS0rn27txVNnXCpsSLk+OLGddUBBenevMCoT44OKN54E19wf5nl+aO7Vt
         eTsRdzKU/erfIOykEEgn4NyN4BO8Ebl9dVb+atU5LDaBOkLZFtdZiNC69Ps0Z5/Jo+W7
         +NoQfyp+2dmtRRQcjzd3esQhS/nf+X8w5DuJ0=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pcmcia@lists.infradead.org
Subject: [PATCH 2/5] Add mkcis - a program that can create .cis from text description
Date: Fri, 24 Sep 2010 20:49:22 +0400
Message-Id: <1285346965-23499-3-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
References: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For CIS files (describing hardware on PCMCIA and some other busses)
binary file isn't the 'preferred for for modification' in most cases.
pcmcia-cs project have developed pack_cis program which can be used
(and was used most probably) to generate .cis files from simple text
descriptions. Import this code under the name of mkcis.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 mkcis/mkcis-lexer.l      |  228 +++++
 mkcis/mkcis-lexer.lex.c  | 2547 ++++++++++++++++++++++++++++++++++++++++++++++
 mkcis/mkcis-parser.tab.c | 2338 ++++++++++++++++++++++++++++++++++++++++++
 mkcis/mkcis-parser.tab.h |  127 +++
 mkcis/mkcis-parser.y     |  383 +++++++
 mkcis/mkcis.c            |  471 +++++++++
 mkcis/mkcis.h            |   49 +
 7 files changed, 6143 insertions(+), 0 deletions(-)
 create mode 100644 mkcis/mkcis-lexer.l
 create mode 100644 mkcis/mkcis-lexer.lex.c
 create mode 100644 mkcis/mkcis-parser.tab.c
 create mode 100644 mkcis/mkcis-parser.tab.h
 create mode 100644 mkcis/mkcis-parser.y
 create mode 100644 mkcis/mkcis.c
 create mode 100644 mkcis/mkcis.h

diff --git a/mkcis/mkcis-lexer.l b/mkcis/mkcis-lexer.l
new file mode 100644
index 0000000..d802e3e
--- /dev/null
+++ b/mkcis/mkcis-lexer.l
@@ -0,0 +1,228 @@
+%{
+/*
+ * lex_cis.l 1.13 2000/06/12 21:34:19
+ *
+ * The contents of this file are subject to the Mozilla Public License
+ * Version 1.1 (the "License"); you may not use this file except in
+ * compliance with the License. You may obtain a copy of the License
+ * at http://www.mozilla.org/MPL/
+ *
+ * Software distributed under the License is distributed on an "AS IS"
+ * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
+ * the License for the specific language governing rights and
+ * limitations under the License.
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * Alternatively, the contents of this file may be used under the
+ * terms of the GNU Public License version 2 (the "GPL"), in which
+ * case the provisions of the GPL are applicable instead of the
+ * above.  If you wish to allow the use of your version of this file
+ * only under the terms of the GPL and not to allow others to use
+ * your version of this file under the MPL, indicate your decision by
+ * deleting the provisions above and replace them with the notice and
+ * other provisions required by the GPL.  If you do not delete the
+ * provisions above, a recipient may use your version of this file
+ * under either the MPL or the GPL.
+ */
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <syslog.h>
+
+#include <cistpl.h>
+
+#include "mkcis.h"
+
+#define YY_NO_INPUT
+#include "mkcis-parser.tab.h"
+
+/* For assembling nice error messages */
+int current_lineno;
+
+static int lex_number(char *);
+static int lex_units(char *, int, int);
+static int lex_float(char *);
+static int lex_string(char *);
+
+%}
+%option nounput
+
+
+int	[0-9]+
+hex	0x[0-9a-fA-F]+
+flt	[0-9]+\.[0-9]*
+str	\"([^"]|\\.)*\"
+
+%%
+
+\n		current_lineno++;
+[ \t]*		/* skip */ ;
+[ ]*[#;].*	/* skip */ ;
+
+funcid		return FUNCID;
+mfc		return MFC;
+manfid		return MANFID;
+vers_1		return VERS_1;
+checksum	return CHECKSUM;
+
+dev_info	return DEV_INFO;
+attr_dev_info	return ATTR_DEV_INFO;
+no_info		return NO_INFO;
+NULL		return lex_number("0");
+ROM		return lex_number("1");
+EPROM		return lex_number("3");
+EEPROM		return lex_number("4");
+FLASH		return lex_number("5");
+SRAM		return lex_number("6");
+DRAM		return lex_number("7");
+fn_specific	return lex_number("13");
+
+config		return CONFIG;
+base		return BASE;
+mask		return MASK;
+last_index	return LAST_INDEX;
+\[post\]	return POST;
+\[rom\]		return ROM;
+
+cftable_entry	return CFTABLE;
+\[default\]	return DEFAULT;
+\[bvd\]		return BVD;
+\[wp\]		return WP;
+\[rdybsy\]	return RDYBSY;
+\[mwait\]	return MWAIT;
+\[audio\]	return AUDIO;
+\[readonly\]	return READONLY;
+\[pwrdown\]	return PWRDOWN;
+
+Vcc		return VCC;
+Vpp1		return VPP1;
+Vpp2		return VPP2;
+Vnom		return VNOM;
+Vmin		return VMIN;
+Vmax		return VMAX;
+Istatic		return ISTATIC;
+Iavg		return IAVG;
+Ipeak		return IPEAK;
+Idown		return IDOWN;
+
+io		return IO;
+memory		return MEM;
+\[8bit\]	return BIT8;
+\[16bit\]	return BIT16;
+\[lines		return LINES;
+\[range\]	return RANGE;
+
+irq		return IRQ_NO;
+\[level\]	return LEVEL;
+\[pulse\]	return PULSE;
+\[shared\]	return SHARED;
+
+timing		return TIMING;
+wait		return WAIT;
+ready		return READY;
+reserved	return RESERVED;
+
+multi_function	return lex_number("0");
+memory_card	return lex_number("1");
+serial_port	return lex_number("2");
+parallel_port	return lex_number("3");
+fixed_disk	return lex_number("4");
+video_adapter	return lex_number("5");
+network_adapter	return lex_number("6");
+aims_card	return lex_number("7");
+scsi_adapter	return lex_number("8");
+
+{int}		return lex_number(yytext);
+{hex}		return lex_number(yytext);
+
+{int}b		return lex_units(yytext, 1, SIZE);
+{int}kb		return lex_units(yytext, 1024, SIZE);
+{int}mb		return lex_units(yytext, 1024*1024, SIZE);
+
+{flt}s		return lex_units(yytext, 1000000000, TIME);
+{flt}ms		return lex_units(yytext, 1000000, TIME);
+{flt}us		return lex_units(yytext, 1000, TIME);
+{flt}ns		return lex_units(yytext, 1, TIME);
+{int}s		return lex_units(yytext, 1000000000, TIME);
+{int}ms		return lex_units(yytext, 1000000, TIME);
+{int}us		return lex_units(yytext, 1000, TIME);
+{int}ns		return lex_units(yytext, 1, TIME);
+
+{flt}V		return lex_units(yytext, 100000, VOLTAGE);
+{flt}mV		return lex_units(yytext, 100, VOLTAGE);
+{flt}uV		return lex_units(yytext, 0.1, VOLTAGE);
+{int}V		return lex_units(yytext, 100000, VOLTAGE);
+{int}mV		return lex_units(yytext, 100, VOLTAGE);
+{int}uV		return lex_units(yytext, 0.1, VOLTAGE);
+
+{flt}A		return lex_units(yytext, 10000000, CURRENT);
+{flt}mA		return lex_units(yytext, 10000, CURRENT);
+{flt}uA		return lex_units(yytext, 10, CURRENT);
+{int}A		return lex_units(yytext, 10000000, CURRENT);
+{int}mA		return lex_units(yytext, 10000, CURRENT);
+{int}uA		return lex_units(yytext, 10, CURRENT);
+
+{flt}		return lex_float(yytext);
+
+{str}		return lex_string(yytext);
+
+.		return yytext[0];
+
+%%
+
+#ifndef yywrap
+int yywrap() { return 1; }
+#endif
+
+/*======================================================================
+
+    Stuff to parse basic data types
+
+======================================================================*/
+
+static int lex_number(char *s)
+{
+    yylval.num = strtoul(s, NULL, 0);
+    return NUMBER;
+}
+
+static int lex_float(char *s)
+{
+    yylval.flt = strtod(s, NULL);
+    return FLOAT;
+}
+
+static int lex_units(char *s, int scale, int token)
+{
+    float f;
+    sscanf(s, "%f", &f);
+    yylval.num = scale*f + 0.5;
+    return token;
+}
+
+static int lex_string(char *s)
+{
+    int n = strlen(s);
+    yylval.str = malloc(n-1);
+    strncpy(yylval.str, s+1, n-2);
+    yylval.str[n-2] = '\0';
+    return STRING;
+}
+
+/*======================================================================
+
+    The main parser entry point
+
+======================================================================*/
+
+void parse_cis(FILE *f)
+{
+    current_lineno = 1;
+    yyrestart(f);
+    yyparse();
+}
+
diff --git a/mkcis/mkcis-lexer.lex.c b/mkcis/mkcis-lexer.lex.c
new file mode 100644
index 0000000..aa3da20
--- /dev/null
+++ b/mkcis/mkcis-lexer.lex.c
@@ -0,0 +1,2547 @@
+#line 2 "firmware/mkcis-lexer.lex.c"
+
+#line 4 "firmware/mkcis-lexer.lex.c"
+
+#define  YY_INT_ALIGNED short int
+
+/* A lexical scanner generated by flex */
+
+#define FLEX_SCANNER
+#define YY_FLEX_MAJOR_VERSION 2
+#define YY_FLEX_MINOR_VERSION 5
+#define YY_FLEX_SUBMINOR_VERSION 35
+#if YY_FLEX_SUBMINOR_VERSION > 0
+#define FLEX_BETA
+#endif
+
+/* First, we deal with  platform-specific or compiler-specific issues. */
+
+/* begin standard C headers. */
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <stdlib.h>
+
+/* end standard C headers. */
+
+/* flex integer type definitions */
+
+#ifndef FLEXINT_H
+#define FLEXINT_H
+
+/* C99 systems have <inttypes.h>. Non-C99 systems may or may not. */
+
+#if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
+
+/* C99 says to define __STDC_LIMIT_MACROS before including stdint.h,
+ * if you want the limit (max/min) macros for int types. 
+ */
+#ifndef __STDC_LIMIT_MACROS
+#define __STDC_LIMIT_MACROS 1
+#endif
+
+#include <inttypes.h>
+typedef int8_t flex_int8_t;
+typedef uint8_t flex_uint8_t;
+typedef int16_t flex_int16_t;
+typedef uint16_t flex_uint16_t;
+typedef int32_t flex_int32_t;
+typedef uint32_t flex_uint32_t;
+#else
+typedef signed char flex_int8_t;
+typedef short int flex_int16_t;
+typedef int flex_int32_t;
+typedef unsigned char flex_uint8_t; 
+typedef unsigned short int flex_uint16_t;
+typedef unsigned int flex_uint32_t;
+
+/* Limits of integral types. */
+#ifndef INT8_MIN
+#define INT8_MIN               (-128)
+#endif
+#ifndef INT16_MIN
+#define INT16_MIN              (-32767-1)
+#endif
+#ifndef INT32_MIN
+#define INT32_MIN              (-2147483647-1)
+#endif
+#ifndef INT8_MAX
+#define INT8_MAX               (127)
+#endif
+#ifndef INT16_MAX
+#define INT16_MAX              (32767)
+#endif
+#ifndef INT32_MAX
+#define INT32_MAX              (2147483647)
+#endif
+#ifndef UINT8_MAX
+#define UINT8_MAX              (255U)
+#endif
+#ifndef UINT16_MAX
+#define UINT16_MAX             (65535U)
+#endif
+#ifndef UINT32_MAX
+#define UINT32_MAX             (4294967295U)
+#endif
+
+#endif /* ! C99 */
+
+#endif /* ! FLEXINT_H */
+
+#ifdef __cplusplus
+
+/* The "const" storage-class-modifier is valid. */
+#define YY_USE_CONST
+
+#else	/* ! __cplusplus */
+
+/* C99 requires __STDC__ to be defined as 1. */
+#if defined (__STDC__)
+
+#define YY_USE_CONST
+
+#endif	/* defined (__STDC__) */
+#endif	/* ! __cplusplus */
+
+#ifdef YY_USE_CONST
+#define yyconst const
+#else
+#define yyconst
+#endif
+
+/* Returned upon end-of-file. */
+#define YY_NULL 0
+
+/* Promotes a possibly negative, possibly signed char to an unsigned
+ * integer for use as an array index.  If the signed char is negative,
+ * we want to instead treat it as an 8-bit unsigned char, hence the
+ * double cast.
+ */
+#define YY_SC_TO_UI(c) ((unsigned int) (unsigned char) c)
+
+/* Enter a start condition.  This macro really ought to take a parameter,
+ * but we do it the disgusting crufty way forced on us by the ()-less
+ * definition of BEGIN.
+ */
+#define BEGIN (yy_start) = 1 + 2 *
+
+/* Translate the current start state into a value that can be later handed
+ * to BEGIN to return to the state.  The YYSTATE alias is for lex
+ * compatibility.
+ */
+#define YY_START (((yy_start) - 1) / 2)
+#define YYSTATE YY_START
+
+/* Action number for EOF rule of a given start state. */
+#define YY_STATE_EOF(state) (YY_END_OF_BUFFER + state + 1)
+
+/* Special action meaning "start processing a new file". */
+#define YY_NEW_FILE yyrestart(yyin  )
+
+#define YY_END_OF_BUFFER_CHAR 0
+
+/* Size of default input buffer. */
+#ifndef YY_BUF_SIZE
+#ifdef __ia64__
+/* On IA-64, the buffer size is 16k, not 8k.
+ * Moreover, YY_BUF_SIZE is 2*YY_READ_BUF_SIZE in the general case.
+ * Ditto for the __ia64__ case accordingly.
+ */
+#define YY_BUF_SIZE 32768
+#else
+#define YY_BUF_SIZE 16384
+#endif /* __ia64__ */
+#endif
+
+/* The state buf must be large enough to hold one state per character in the main buffer.
+ */
+#define YY_STATE_BUF_SIZE   ((YY_BUF_SIZE + 2) * sizeof(yy_state_type))
+
+#ifndef YY_TYPEDEF_YY_BUFFER_STATE
+#define YY_TYPEDEF_YY_BUFFER_STATE
+typedef struct yy_buffer_state *YY_BUFFER_STATE;
+#endif
+
+extern int yyleng;
+
+extern FILE *yyin, *yyout;
+
+#define EOB_ACT_CONTINUE_SCAN 0
+#define EOB_ACT_END_OF_FILE 1
+#define EOB_ACT_LAST_MATCH 2
+
+    #define YY_LESS_LINENO(n)
+    
+/* Return all but the first "n" matched characters back to the input stream. */
+#define yyless(n) \
+	do \
+		{ \
+		/* Undo effects of setting up yytext. */ \
+        int yyless_macro_arg = (n); \
+        YY_LESS_LINENO(yyless_macro_arg);\
+		*yy_cp = (yy_hold_char); \
+		YY_RESTORE_YY_MORE_OFFSET \
+		(yy_c_buf_p) = yy_cp = yy_bp + yyless_macro_arg - YY_MORE_ADJ; \
+		YY_DO_BEFORE_ACTION; /* set up yytext again */ \
+		} \
+	while ( 0 )
+
+#define unput(c) yyunput( c, (yytext_ptr)  )
+
+#ifndef YY_TYPEDEF_YY_SIZE_T
+#define YY_TYPEDEF_YY_SIZE_T
+typedef size_t yy_size_t;
+#endif
+
+#ifndef YY_STRUCT_YY_BUFFER_STATE
+#define YY_STRUCT_YY_BUFFER_STATE
+struct yy_buffer_state
+	{
+	FILE *yy_input_file;
+
+	char *yy_ch_buf;		/* input buffer */
+	char *yy_buf_pos;		/* current position in input buffer */
+
+	/* Size of input buffer in bytes, not including room for EOB
+	 * characters.
+	 */
+	yy_size_t yy_buf_size;
+
+	/* Number of characters read into yy_ch_buf, not including EOB
+	 * characters.
+	 */
+	int yy_n_chars;
+
+	/* Whether we "own" the buffer - i.e., we know we created it,
+	 * and can realloc() it to grow it, and should free() it to
+	 * delete it.
+	 */
+	int yy_is_our_buffer;
+
+	/* Whether this is an "interactive" input source; if so, and
+	 * if we're using stdio for input, then we want to use getc()
+	 * instead of fread(), to make sure we stop fetching input after
+	 * each newline.
+	 */
+	int yy_is_interactive;
+
+	/* Whether we're considered to be at the beginning of a line.
+	 * If so, '^' rules will be active on the next match, otherwise
+	 * not.
+	 */
+	int yy_at_bol;
+
+    int yy_bs_lineno; /**< The line count. */
+    int yy_bs_column; /**< The column count. */
+    
+	/* Whether to try to fill the input buffer when we reach the
+	 * end of it.
+	 */
+	int yy_fill_buffer;
+
+	int yy_buffer_status;
+
+#define YY_BUFFER_NEW 0
+#define YY_BUFFER_NORMAL 1
+	/* When an EOF's been seen but there's still some text to process
+	 * then we mark the buffer as YY_EOF_PENDING, to indicate that we
+	 * shouldn't try reading from the input source any more.  We might
+	 * still have a bunch of tokens to match, though, because of
+	 * possible backing-up.
+	 *
+	 * When we actually see the EOF, we change the status to "new"
+	 * (via yyrestart()), so that the user can continue scanning by
+	 * just pointing yyin at a new input file.
+	 */
+#define YY_BUFFER_EOF_PENDING 2
+
+	};
+#endif /* !YY_STRUCT_YY_BUFFER_STATE */
+
+/* Stack of input buffers. */
+static size_t yy_buffer_stack_top = 0; /**< index of top of stack. */
+static size_t yy_buffer_stack_max = 0; /**< capacity of stack. */
+static YY_BUFFER_STATE * yy_buffer_stack = 0; /**< Stack as an array. */
+
+/* We provide macros for accessing buffer states in case in the
+ * future we want to put the buffer states in a more general
+ * "scanner state".
+ *
+ * Returns the top of the stack, or NULL.
+ */
+#define YY_CURRENT_BUFFER ( (yy_buffer_stack) \
+                          ? (yy_buffer_stack)[(yy_buffer_stack_top)] \
+                          : NULL)
+
+/* Same as previous macro, but useful when we know that the buffer stack is not
+ * NULL or when we need an lvalue. For internal use only.
+ */
+#define YY_CURRENT_BUFFER_LVALUE (yy_buffer_stack)[(yy_buffer_stack_top)]
+
+/* yy_hold_char holds the character lost when yytext is formed. */
+static char yy_hold_char;
+static int yy_n_chars;		/* number of characters read into yy_ch_buf */
+int yyleng;
+
+/* Points to current character in buffer. */
+static char *yy_c_buf_p = (char *) 0;
+static int yy_init = 0;		/* whether we need to initialize */
+static int yy_start = 0;	/* start state number */
+
+/* Flag which is used to allow yywrap()'s to do buffer switches
+ * instead of setting up a fresh yyin.  A bit of a hack ...
+ */
+static int yy_did_buffer_switch_on_eof;
+
+void yyrestart (FILE *input_file  );
+void yy_switch_to_buffer (YY_BUFFER_STATE new_buffer  );
+YY_BUFFER_STATE yy_create_buffer (FILE *file,int size  );
+void yy_delete_buffer (YY_BUFFER_STATE b  );
+void yy_flush_buffer (YY_BUFFER_STATE b  );
+void yypush_buffer_state (YY_BUFFER_STATE new_buffer  );
+void yypop_buffer_state (void );
+
+static void yyensure_buffer_stack (void );
+static void yy_load_buffer_state (void );
+static void yy_init_buffer (YY_BUFFER_STATE b,FILE *file  );
+
+#define YY_FLUSH_BUFFER yy_flush_buffer(YY_CURRENT_BUFFER )
+
+YY_BUFFER_STATE yy_scan_buffer (char *base,yy_size_t size  );
+YY_BUFFER_STATE yy_scan_string (yyconst char *yy_str  );
+YY_BUFFER_STATE yy_scan_bytes (yyconst char *bytes,int len  );
+
+void *yyalloc (yy_size_t  );
+void *yyrealloc (void *,yy_size_t  );
+void yyfree (void *  );
+
+#define yy_new_buffer yy_create_buffer
+
+#define yy_set_interactive(is_interactive) \
+	{ \
+	if ( ! YY_CURRENT_BUFFER ){ \
+        yyensure_buffer_stack (); \
+		YY_CURRENT_BUFFER_LVALUE =    \
+            yy_create_buffer(yyin,YY_BUF_SIZE ); \
+	} \
+	YY_CURRENT_BUFFER_LVALUE->yy_is_interactive = is_interactive; \
+	}
+
+#define yy_set_bol(at_bol) \
+	{ \
+	if ( ! YY_CURRENT_BUFFER ){\
+        yyensure_buffer_stack (); \
+		YY_CURRENT_BUFFER_LVALUE =    \
+            yy_create_buffer(yyin,YY_BUF_SIZE ); \
+	} \
+	YY_CURRENT_BUFFER_LVALUE->yy_at_bol = at_bol; \
+	}
+
+#define YY_AT_BOL() (YY_CURRENT_BUFFER_LVALUE->yy_at_bol)
+
+/* Begin user sect3 */
+
+typedef unsigned char YY_CHAR;
+
+FILE *yyin = (FILE *) 0, *yyout = (FILE *) 0;
+
+typedef int yy_state_type;
+
+extern int yylineno;
+
+int yylineno = 1;
+
+extern char *yytext;
+#define yytext_ptr yytext
+
+static yy_state_type yy_get_previous_state (void );
+static yy_state_type yy_try_NUL_trans (yy_state_type current_state  );
+static int yy_get_next_buffer (void );
+static void yy_fatal_error (yyconst char msg[]  );
+
+/* Done after the current pattern has been matched and before the
+ * corresponding action - sets up yytext.
+ */
+#define YY_DO_BEFORE_ACTION \
+	(yytext_ptr) = yy_bp; \
+	yyleng = (size_t) (yy_cp - yy_bp); \
+	(yy_hold_char) = *yy_cp; \
+	*yy_cp = '\0'; \
+	(yy_c_buf_p) = yy_cp;
+
+#define YY_NUM_RULES 96
+#define YY_END_OF_BUFFER 97
+/* This struct is not used in this scanner,
+   but its presence is necessary. */
+struct yy_trans_info
+	{
+	flex_int32_t yy_verify;
+	flex_int32_t yy_nxt;
+	};
+static yyconst flex_int16_t yy_accept[442] =
+    {   0,
+        2,    2,   97,   95,    2,    1,    2,   95,    3,   68,
+       68,   95,   95,   95,   95,   95,   95,   95,   95,   95,
+       95,   95,   95,   95,   95,   95,   95,   95,   95,   95,
+       95,   95,   95,   95,   95,    2,    2,    3,    0,   94,
+        0,    3,   93,   68,   90,   84,   70,    0,    0,    0,
+       77,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,   45,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+
+        0,    0,    0,    0,    0,    0,    0,   94,    0,   93,
+       87,   81,    0,    0,   73,    0,   71,   91,   85,   72,
+       78,   80,   92,   86,   79,   69,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,   13,    0,   35,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,   51,
+        0,    0,    0,    0,    5,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,   88,   82,   74,
+       76,   89,   83,   75,   18,    0,    0,    0,   42,    0,
+
+        0,    0,   12,   17,   40,   39,   38,   36,   37,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,   29,    0,    0,   21,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,   22,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,   56,    0,   14,   16,   44,   43,    0,    0,    0,
+        0,   28,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,   25,    0,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+       57,    0,    0,    0,    0,    0,    0,   15,    0,    0,
+
+       47,    0,    0,    0,   49,    0,   24,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,   20,    0,    0,
+        0,    4,    0,    6,   46,    0,    0,    0,    0,    0,
+        0,    0,   55,    7,    0,   41,   48,   32,    0,   52,
+       31,   53,    0,   50,    0,    0,    0,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,   11,    0,
+        0,    0,    0,    0,    0,    0,   30,    0,   54,    0,
+        0,    0,    8,    9,    0,    0,    0,    0,    0,    0,
+        0,   58,    0,    0,    0,   27,   34,    0,   66,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+
+        0,   33,    0,    0,   63,    0,   23,    0,    0,    0,
+        0,    0,    0,    0,    0,    0,   19,   60,    0,    0,
+        0,    0,   61,    0,    0,    0,    0,    0,    0,   67,
+        0,   10,   26,    0,    0,   62,   64,   59,    0,   65,
+        0
+    } ;
+
+static yyconst flex_int32_t yy_ec[256] =
+    {   0,
+        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    4,    1,    5,    6,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    7,    1,    8,    9,   10,
+       11,   11,   11,   12,   11,   13,   11,    1,    6,    1,
+        1,    1,    1,    1,   14,   15,   15,   16,   17,   18,
+        1,   19,   20,    1,    1,   21,   22,   23,   24,   25,
+        1,   26,   27,    1,   28,   29,    1,    1,    1,    1,
+       30,   31,   32,    1,   33,    1,   34,   35,   36,   37,
+
+       38,   39,   40,   41,   42,    1,   43,   44,   45,   46,
+       47,   48,   49,   50,   51,   52,   53,   54,   55,   56,
+       57,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1
+    } ;
+
+static yyconst flex_int32_t yy_meta[58] =
+    {   0,
+        1,    1,    2,    1,    1,    1,    1,    3,    3,    3,
+        3,    3,    3,    3,    3,    3,    3,    3,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    3,    3,    3,    3,    3,    3,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1
+    } ;
+
+static yyconst flex_int16_t yy_base[446] =
+    {   0,
+        0,    0,  497,  498,   56,  498,   57,   57,    0,   82,
+      440,  469,   47,  473,   31,  465,  468,  465,   30,  130,
+       25,  456,   58,  451,   27,   24,  454,   47,   60,  453,
+      448,   65,  443,   45,  450,  100,  104,    0,  109,  498,
+      110,    0,  178,  427,  498,  498,  498,  447,   95,  430,
+      498,  102,    0,  466,  454,  452,  463,  422,  428,  436,
+      421,  451,  449,  456,  433,   78,  421,  419,  454,  430,
+      411,  409,  424,   80,  406,   79,  110,  419,  411,  413,
+      405,  405,  403,  416,  407,  398,  395,  417,  403,  498,
+      399,  396,   91,  401,  409,  400,  391,  409,  391,   85,
+
+      389,  389,  393,  387,  399,  393,  118,  124,  151,    0,
+      498,  498,  144,  383,  498,  147,  498,  498,  498,  498,
+      498,  498,  498,  498,  498,    0,  411,  406,  407,  403,
+      389,  373,  393,  392,  404,  498,  402,  498,  367,  376,
+      376,  141,  385,  377,  381,  380,  377,  361,  368,  379,
+      361,  367,  360,  363,  351,  373,  361,  371,  372,  352,
+      352,  363,  366,  363,  359,  364,  358,  344,  358,  498,
+      341,  353,  348,  343,  498,  337,  333,  345,  352,  348,
+      346,  341,  340,  339,  329,  341,  326,  498,  498,  498,
+      498,  498,  498,  498,  498,  353,  354,  356,  498,  328,
+
+      330,  320,  498,  498,  498,  498,  498,  498,  498,  329,
+      318,  327,  336,  333,  328,  327,  322,  311,  311,  324,
+      320,  324,  321,  325,  306,  498,  322,  321,  498,  318,
+      309,  309,  308,  312,  300,  305,  313,  303,  498,  294,
+      301,  295,  295,  296,  282,  288,  304,  302,  289,  301,
+      286,  498,  310,  498,  498,  498,  498,  289,  278,  297,
+      281,  498,  274,  282,  274,  272,  291,  284,  274,  282,
+      268,  271,  498,  279,  280,  278,  270,  262,  272,  265,
+      277,  271,  271,  265,  269,  248,  271,  253,  263,  257,
+      498,  246,  265,  254,  257,  287,  262,  498,  258,  261,
+
+      498,  260,  247,  258,  498,  257,  498,  256,  232,  254,
+      228,  238,  246,  248,  243,  242,  226,  498,  239,  240,
+      240,  498,  229,  498,  241,  234,  229,  224,  232,  231,
+      231,  234,  498,  498,  232,  498,  498,  498,  213,  498,
+      498,  498,  218,  498,  231,  218,  229,  210,  205,  225,
+      212,  209,  213,  212,  216,  216,  198,  217,  498,  205,
+      211,  213,  198,  208,  212,  211,  498,  185,  498,  204,
+      203,  192,  498,  498,  177,  188,  188,  191,  176,  187,
+      187,  498,  171,  171,  183,  498,  498,  184,  498,  173,
+      168,  170,  170,  155,  160,  173,  171,  158,  153,  154,
+
+      155,  498,  156,  149,  498,  164,  498,  162,  145,  162,
+      147,  155,  132,  131,  140,  127,  498,  498,  130,  123,
+      120,  119,  498,  130,  119,  106,  115,  108,  107,  498,
+      102,  498,  498,   99,   83,  498,  498,  498,   34,  498,
+      498,  231,  234,  237,   67
+    } ;
+
+static yyconst flex_int16_t yy_def[446] =
+    {   0,
+      441,    1,  441,  441,  441,  441,  441,  442,  443,  441,
+       10,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  443,  442,  441,
+      444,  443,  441,   10,  441,  441,  441,  441,  441,  441,
+      441,  441,  445,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+
+      441,  441,  441,  441,  441,  441,  442,  442,  444,   43,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  445,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+        0,  441,  441,  441,  441
+    } ;
+
+static yyconst flex_int16_t yy_nxt[556] =
+    {   0,
+        4,    5,    6,    7,    8,    9,    4,   10,   11,   11,
+       11,   11,   11,    4,    4,   12,   13,   14,    4,   15,
+        4,    4,   16,    4,    4,   17,   18,    4,   19,   20,
+        4,    4,    4,   21,   22,   23,   24,    4,   25,    4,
+        4,   26,    4,   27,   28,   29,    4,   30,    4,   31,
+       32,   33,    4,   34,   35,    4,    4,   36,   36,   36,
+       37,   40,   38,   55,   58,   65,   80,   59,   87,  126,
+       90,   56,   88,   91,   66,   67,   81,   68,   60,   89,
+       93,   61,  104,  440,   94,   95,  105,   41,   43,   44,
+       44,   44,   44,   44,   44,   45,   83,   97,   84,   96,
+
+      101,   36,  102,   36,   85,   36,   98,   37,  118,   38,
+       46,  139,   39,   40,  108,  123,   47,  148,  180,  140,
+      439,  149,   40,  119,   48,  151,   49,   50,   40,  120,
+      124,  152,   51,  153,   52,  181,  172,   53,   69,   41,
+      109,  173,   70,  154,  438,  121,  155,  156,   41,  208,
+      209,  437,  125,   39,   41,  108,  157,  188,  436,  435,
+      192,  434,  433,   71,   72,  432,   73,  431,  430,  429,
+      428,  427,  189,   74,   75,  193,  426,   76,  425,   77,
+       78,  109,  424,  423,   79,  110,  110,  110,  110,  110,
+      110,  111,  422,  421,  190,  420,  419,  194,  418,  417,
+
+      416,  415,  414,  413,  412,  411,  112,  410,  409,  408,
+      407,  406,  405,  404,  403,  402,  401,  400,  399,  398,
+      397,  396,  113,  114,  395,  394,  393,  392,  115,  391,
+      116,   39,   39,   39,   42,  390,   42,  107,  107,  107,
+      389,  388,  387,  386,  385,  384,  383,  382,  381,  380,
+      379,  378,  377,  376,  375,  374,  373,  372,  371,  370,
+      369,  368,  367,  366,  365,  364,  363,  362,  361,  360,
+      359,  358,  357,  356,  355,  354,  353,  352,  351,  350,
+      349,  348,  347,  346,  345,  344,  343,  342,  341,  340,
+      339,  338,  337,  336,  335,  334,  333,  332,  331,  330,
+
+      329,  328,  327,  326,  325,  324,  323,  322,  321,  320,
+      319,  318,  317,  316,  315,  314,  313,  312,  311,  310,
+      309,  308,  307,  306,  305,  304,  303,  302,  301,  300,
+      299,  298,  297,  296,  295,  294,  293,  292,  291,  290,
+      289,  288,  287,  286,  285,  284,  283,  282,  281,  280,
+      279,  278,  277,  276,  275,  274,  273,  272,  271,  270,
+      269,  268,  267,  266,  265,  264,  263,  262,  261,  260,
+      259,  258,  257,  256,  255,  254,  253,  252,  251,  250,
+      249,  248,  247,  246,  245,  244,  243,  242,  241,  240,
+      239,  238,  237,  236,  235,  234,  233,  232,  231,  230,
+
+      229,  228,  227,  226,  225,  224,  223,  222,  221,  220,
+      219,  218,  217,  216,  215,  214,  213,  212,  211,  210,
+      207,  206,  205,  204,  203,  202,  201,  200,  199,  198,
+      197,  196,  195,  191,  187,  186,  185,  184,  183,  182,
+      179,  178,  177,  176,  175,  174,  171,  170,  169,  168,
+      167,  166,  165,  164,  163,  162,  161,  160,  159,  158,
+      150,  147,  146,  145,  144,  143,  142,  141,  138,  137,
+      136,  135,  134,  133,  132,  131,  130,  129,  128,  127,
+      122,  117,  441,  106,  103,  100,   99,   92,   86,   82,
+       64,   63,   62,   57,   54,  441,  441,    3,  441,  441,
+
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441
+    } ;
+
+static yyconst flex_int16_t yy_chk[556] =
+    {   0,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
+        1,    1,    1,    1,    1,    1,    1,    5,    7,    5,
+        7,    8,    7,   13,   15,   19,   21,   15,   25,  445,
+       26,   13,   25,   26,   19,   19,   21,   19,   15,   25,
+       28,   15,   34,  439,   28,   28,   34,    8,   10,   10,
+       10,   10,   10,   10,   10,   10,   23,   29,   23,   28,
+
+       32,   36,   32,   36,   23,   37,   29,   37,   49,   37,
+       10,   66,   41,   39,   41,   52,   10,   74,  100,   66,
+      435,   74,  107,   49,   10,   76,   10,   10,  108,   49,
+       52,   76,   10,   76,   10,  100,   93,   10,   20,   39,
+       41,   93,   20,   77,  434,   49,   77,   77,  107,  142,
+      142,  431,   52,  109,  108,  109,   77,  113,  429,  428,
+      116,  427,  426,   20,   20,  425,   20,  424,  422,  421,
+      420,  419,  113,   20,   20,  116,  416,   20,  415,   20,
+       20,  109,  414,  413,   20,   43,   43,   43,   43,   43,
+       43,   43,  412,  411,  113,  410,  409,  116,  408,  406,
+
+      404,  403,  401,  400,  399,  398,   43,  397,  396,  395,
+      394,  393,  392,  391,  390,  388,  385,  384,  383,  381,
+      380,  379,   43,   43,  378,  377,  376,  375,   43,  372,
+       43,  442,  442,  442,  443,  371,  443,  444,  444,  444,
+      370,  368,  366,  365,  364,  363,  362,  361,  360,  358,
+      357,  356,  355,  354,  353,  352,  351,  350,  349,  348,
+      347,  346,  345,  343,  339,  335,  332,  331,  330,  329,
+      328,  327,  326,  325,  323,  321,  320,  319,  317,  316,
+      315,  314,  313,  312,  311,  310,  309,  308,  306,  304,
+      303,  302,  300,  299,  297,  296,  295,  294,  293,  292,
+
+      290,  289,  288,  287,  286,  285,  284,  283,  282,  281,
+      280,  279,  278,  277,  276,  275,  274,  272,  271,  270,
+      269,  268,  267,  266,  265,  264,  263,  261,  260,  259,
+      258,  253,  251,  250,  249,  248,  247,  246,  245,  244,
+      243,  242,  241,  240,  238,  237,  236,  235,  234,  233,
+      232,  231,  230,  228,  227,  225,  224,  223,  222,  221,
+      220,  219,  218,  217,  216,  215,  214,  213,  212,  211,
+      210,  202,  201,  200,  198,  197,  196,  187,  186,  185,
+      184,  183,  182,  181,  180,  179,  178,  177,  176,  174,
+      173,  172,  171,  169,  168,  167,  166,  165,  164,  163,
+
+      162,  161,  160,  159,  158,  157,  156,  155,  154,  153,
+      152,  151,  150,  149,  148,  147,  146,  145,  144,  143,
+      141,  140,  139,  137,  135,  134,  133,  132,  131,  130,
+      129,  128,  127,  114,  106,  105,  104,  103,  102,  101,
+       99,   98,   97,   96,   95,   94,   92,   91,   89,   88,
+       87,   86,   85,   84,   83,   82,   81,   80,   79,   78,
+       75,   73,   72,   71,   70,   69,   68,   67,   65,   64,
+       63,   62,   61,   60,   59,   58,   57,   56,   55,   54,
+       50,   48,   44,   35,   33,   31,   30,   27,   24,   22,
+       18,   17,   16,   14,   12,   11,    3,  441,  441,  441,
+
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441,  441,  441,  441,  441,  441,
+      441,  441,  441,  441,  441
+    } ;
+
+static yy_state_type yy_last_accepting_state;
+static char *yy_last_accepting_cpos;
+
+extern int yy_flex_debug;
+int yy_flex_debug = 0;
+
+/* The intent behind this definition is that it'll catch
+ * any uses of REJECT which flex missed.
+ */
+#define REJECT reject_used_but_not_detected
+#define yymore() yymore_used_but_not_detected
+#define YY_MORE_ADJ 0
+#define YY_RESTORE_YY_MORE_OFFSET
+char *yytext;
+#line 1 "firmware/mkcis-lexer.l"
+#line 2 "firmware/mkcis-lexer.l"
+/*
+ * lex_cis.l 1.13 2000/06/12 21:34:19
+ *
+ * The contents of this file are subject to the Mozilla Public License
+ * Version 1.1 (the "License"); you may not use this file except in
+ * compliance with the License. You may obtain a copy of the License
+ * at http://www.mozilla.org/MPL/
+ *
+ * Software distributed under the License is distributed on an "AS IS"
+ * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
+ * the License for the specific language governing rights and
+ * limitations under the License.
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * Alternatively, the contents of this file may be used under the
+ * terms of the GNU Public License version 2 (the "GPL"), in which
+ * case the provisions of the GPL are applicable instead of the
+ * above.  If you wish to allow the use of your version of this file
+ * only under the terms of the GPL and not to allow others to use
+ * your version of this file under the MPL, indicate your decision by
+ * deleting the provisions above and replace them with the notice and
+ * other provisions required by the GPL.  If you do not delete the
+ * provisions above, a recipient may use your version of this file
+ * under either the MPL or the GPL.
+ */
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <syslog.h>
+
+#include <cistpl.h>
+
+#include "mkcis.h"
+
+#define YY_NO_INPUT
+#include "mkcis-parser.tab.h"
+
+/* For assembling nice error messages */
+int current_lineno;
+
+static int lex_number(char *);
+static int lex_units(char *, int, int);
+static int lex_float(char *);
+static int lex_string(char *);
+
+#line 778 "firmware/mkcis-lexer.lex.c"
+
+#define INITIAL 0
+
+#ifndef YY_NO_UNISTD_H
+/* Special case for "unistd.h", since it is non-ANSI. We include it way
+ * down here because we want the user's section 1 to have been scanned first.
+ * The user has a chance to override it with an option.
+ */
+#include <unistd.h>
+#endif
+
+#ifndef YY_EXTRA_TYPE
+#define YY_EXTRA_TYPE void *
+#endif
+
+static int yy_init_globals (void );
+
+/* Accessor methods to globals.
+   These are made visible to non-reentrant scanners for convenience. */
+
+int yylex_destroy (void );
+
+int yyget_debug (void );
+
+void yyset_debug (int debug_flag  );
+
+YY_EXTRA_TYPE yyget_extra (void );
+
+void yyset_extra (YY_EXTRA_TYPE user_defined  );
+
+FILE *yyget_in (void );
+
+void yyset_in  (FILE * in_str  );
+
+FILE *yyget_out (void );
+
+void yyset_out  (FILE * out_str  );
+
+int yyget_leng (void );
+
+char *yyget_text (void );
+
+int yyget_lineno (void );
+
+void yyset_lineno (int line_number  );
+
+/* Macros after this point can all be overridden by user definitions in
+ * section 1.
+ */
+
+#ifndef YY_SKIP_YYWRAP
+#ifdef __cplusplus
+extern "C" int yywrap (void );
+#else
+extern int yywrap (void );
+#endif
+#endif
+
+#ifndef yytext_ptr
+static void yy_flex_strncpy (char *,yyconst char *,int );
+#endif
+
+#ifdef YY_NEED_STRLEN
+static int yy_flex_strlen (yyconst char * );
+#endif
+
+#ifndef YY_NO_INPUT
+
+#ifdef __cplusplus
+static int yyinput (void );
+#else
+static int input (void );
+#endif
+
+#endif
+
+/* Amount of stuff to slurp up with each read. */
+#ifndef YY_READ_BUF_SIZE
+#ifdef __ia64__
+/* On IA-64, the buffer size is 16k, not 8k */
+#define YY_READ_BUF_SIZE 16384
+#else
+#define YY_READ_BUF_SIZE 8192
+#endif /* __ia64__ */
+#endif
+
+/* Copy whatever the last rule matched to the standard output. */
+#ifndef ECHO
+/* This used to be an fputs(), but since the string might contain NUL's,
+ * we now use fwrite().
+ */
+#define ECHO do { if (fwrite( yytext, yyleng, 1, yyout )) {} } while (0)
+#endif
+
+/* Gets input and stuffs it into "buf".  number of characters read, or YY_NULL,
+ * is returned in "result".
+ */
+#ifndef YY_INPUT
+#define YY_INPUT(buf,result,max_size) \
+	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
+		{ \
+		int c = '*'; \
+		size_t n; \
+		for ( n = 0; n < max_size && \
+			     (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
+			buf[n] = (char) c; \
+		if ( c == '\n' ) \
+			buf[n++] = (char) c; \
+		if ( c == EOF && ferror( yyin ) ) \
+			YY_FATAL_ERROR( "input in flex scanner failed" ); \
+		result = n; \
+		} \
+	else \
+		{ \
+		errno=0; \
+		while ( (result = fread(buf, 1, max_size, yyin))==0 && ferror(yyin)) \
+			{ \
+			if( errno != EINTR) \
+				{ \
+				YY_FATAL_ERROR( "input in flex scanner failed" ); \
+				break; \
+				} \
+			errno=0; \
+			clearerr(yyin); \
+			} \
+		}\
+\
+
+#endif
+
+/* No semi-colon after return; correct usage is to write "yyterminate();" -
+ * we don't want an extra ';' after the "return" because that will cause
+ * some compilers to complain about unreachable statements.
+ */
+#ifndef yyterminate
+#define yyterminate() return YY_NULL
+#endif
+
+/* Number of entries by which start-condition stack grows. */
+#ifndef YY_START_STACK_INCR
+#define YY_START_STACK_INCR 25
+#endif
+
+/* Report a fatal error. */
+#ifndef YY_FATAL_ERROR
+#define YY_FATAL_ERROR(msg) yy_fatal_error( msg )
+#endif
+
+/* end tables serialization structures and prototypes */
+
+/* Default declaration of generated scanner - a define so the user can
+ * easily add parameters.
+ */
+#ifndef YY_DECL
+#define YY_DECL_IS_OURS 1
+
+extern int yylex (void);
+
+#define YY_DECL int yylex (void)
+#endif /* !YY_DECL */
+
+/* Code executed at the beginning of each rule, after yytext and yyleng
+ * have been set up.
+ */
+#ifndef YY_USER_ACTION
+#define YY_USER_ACTION
+#endif
+
+/* Code executed at the end of each rule. */
+#ifndef YY_BREAK
+#define YY_BREAK break;
+#endif
+
+#define YY_RULE_SETUP \
+	YY_USER_ACTION
+
+/** The main scanner function which does all the work.
+ */
+YY_DECL
+{
+	register yy_state_type yy_current_state;
+	register char *yy_cp, *yy_bp;
+	register int yy_act;
+    
+#line 60 "firmware/mkcis-lexer.l"
+
+
+#line 966 "firmware/mkcis-lexer.lex.c"
+
+	if ( !(yy_init) )
+		{
+		(yy_init) = 1;
+
+#ifdef YY_USER_INIT
+		YY_USER_INIT;
+#endif
+
+		if ( ! (yy_start) )
+			(yy_start) = 1;	/* first start state */
+
+		if ( ! yyin )
+			yyin = stdin;
+
+		if ( ! yyout )
+			yyout = stdout;
+
+		if ( ! YY_CURRENT_BUFFER ) {
+			yyensure_buffer_stack ();
+			YY_CURRENT_BUFFER_LVALUE =
+				yy_create_buffer(yyin,YY_BUF_SIZE );
+		}
+
+		yy_load_buffer_state( );
+		}
+
+	while ( 1 )		/* loops until end-of-file is reached */
+		{
+		yy_cp = (yy_c_buf_p);
+
+		/* Support of yytext. */
+		*yy_cp = (yy_hold_char);
+
+		/* yy_bp points to the position in yy_ch_buf of the start of
+		 * the current run.
+		 */
+		yy_bp = yy_cp;
+
+		yy_current_state = (yy_start);
+yy_match:
+		do
+			{
+			register YY_CHAR yy_c = yy_ec[YY_SC_TO_UI(*yy_cp)];
+			if ( yy_accept[yy_current_state] )
+				{
+				(yy_last_accepting_state) = yy_current_state;
+				(yy_last_accepting_cpos) = yy_cp;
+				}
+			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
+				{
+				yy_current_state = (int) yy_def[yy_current_state];
+				if ( yy_current_state >= 442 )
+					yy_c = yy_meta[(unsigned int) yy_c];
+				}
+			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+			++yy_cp;
+			}
+		while ( yy_base[yy_current_state] != 498 );
+
+yy_find_action:
+		yy_act = yy_accept[yy_current_state];
+		if ( yy_act == 0 )
+			{ /* have to back up */
+			yy_cp = (yy_last_accepting_cpos);
+			yy_current_state = (yy_last_accepting_state);
+			yy_act = yy_accept[yy_current_state];
+			}
+
+		YY_DO_BEFORE_ACTION;
+
+do_action:	/* This label is used only to access EOF actions. */
+
+		switch ( yy_act )
+	{ /* beginning of action switch */
+			case 0: /* must back up */
+			/* undo the effects of YY_DO_BEFORE_ACTION */
+			*yy_cp = (yy_hold_char);
+			yy_cp = (yy_last_accepting_cpos);
+			yy_current_state = (yy_last_accepting_state);
+			goto yy_find_action;
+
+case 1:
+/* rule 1 can match eol */
+YY_RULE_SETUP
+#line 62 "firmware/mkcis-lexer.l"
+current_lineno++;
+	YY_BREAK
+case 2:
+YY_RULE_SETUP
+#line 63 "firmware/mkcis-lexer.l"
+/* skip */ ;
+	YY_BREAK
+case 3:
+YY_RULE_SETUP
+#line 64 "firmware/mkcis-lexer.l"
+/* skip */ ;
+	YY_BREAK
+case 4:
+YY_RULE_SETUP
+#line 66 "firmware/mkcis-lexer.l"
+return FUNCID;
+	YY_BREAK
+case 5:
+YY_RULE_SETUP
+#line 67 "firmware/mkcis-lexer.l"
+return MFC;
+	YY_BREAK
+case 6:
+YY_RULE_SETUP
+#line 68 "firmware/mkcis-lexer.l"
+return MANFID;
+	YY_BREAK
+case 7:
+YY_RULE_SETUP
+#line 69 "firmware/mkcis-lexer.l"
+return VERS_1;
+	YY_BREAK
+case 8:
+YY_RULE_SETUP
+#line 70 "firmware/mkcis-lexer.l"
+return CHECKSUM;
+	YY_BREAK
+case 9:
+YY_RULE_SETUP
+#line 72 "firmware/mkcis-lexer.l"
+return DEV_INFO;
+	YY_BREAK
+case 10:
+YY_RULE_SETUP
+#line 73 "firmware/mkcis-lexer.l"
+return ATTR_DEV_INFO;
+	YY_BREAK
+case 11:
+YY_RULE_SETUP
+#line 74 "firmware/mkcis-lexer.l"
+return NO_INFO;
+	YY_BREAK
+case 12:
+YY_RULE_SETUP
+#line 75 "firmware/mkcis-lexer.l"
+return lex_number("0");
+	YY_BREAK
+case 13:
+YY_RULE_SETUP
+#line 76 "firmware/mkcis-lexer.l"
+return lex_number("1");
+	YY_BREAK
+case 14:
+YY_RULE_SETUP
+#line 77 "firmware/mkcis-lexer.l"
+return lex_number("3");
+	YY_BREAK
+case 15:
+YY_RULE_SETUP
+#line 78 "firmware/mkcis-lexer.l"
+return lex_number("4");
+	YY_BREAK
+case 16:
+YY_RULE_SETUP
+#line 79 "firmware/mkcis-lexer.l"
+return lex_number("5");
+	YY_BREAK
+case 17:
+YY_RULE_SETUP
+#line 80 "firmware/mkcis-lexer.l"
+return lex_number("6");
+	YY_BREAK
+case 18:
+YY_RULE_SETUP
+#line 81 "firmware/mkcis-lexer.l"
+return lex_number("7");
+	YY_BREAK
+case 19:
+YY_RULE_SETUP
+#line 82 "firmware/mkcis-lexer.l"
+return lex_number("13");
+	YY_BREAK
+case 20:
+YY_RULE_SETUP
+#line 84 "firmware/mkcis-lexer.l"
+return CONFIG;
+	YY_BREAK
+case 21:
+YY_RULE_SETUP
+#line 85 "firmware/mkcis-lexer.l"
+return BASE;
+	YY_BREAK
+case 22:
+YY_RULE_SETUP
+#line 86 "firmware/mkcis-lexer.l"
+return MASK;
+	YY_BREAK
+case 23:
+YY_RULE_SETUP
+#line 87 "firmware/mkcis-lexer.l"
+return LAST_INDEX;
+	YY_BREAK
+case 24:
+YY_RULE_SETUP
+#line 88 "firmware/mkcis-lexer.l"
+return POST;
+	YY_BREAK
+case 25:
+YY_RULE_SETUP
+#line 89 "firmware/mkcis-lexer.l"
+return ROM;
+	YY_BREAK
+case 26:
+YY_RULE_SETUP
+#line 91 "firmware/mkcis-lexer.l"
+return CFTABLE;
+	YY_BREAK
+case 27:
+YY_RULE_SETUP
+#line 92 "firmware/mkcis-lexer.l"
+return DEFAULT;
+	YY_BREAK
+case 28:
+YY_RULE_SETUP
+#line 93 "firmware/mkcis-lexer.l"
+return BVD;
+	YY_BREAK
+case 29:
+YY_RULE_SETUP
+#line 94 "firmware/mkcis-lexer.l"
+return WP;
+	YY_BREAK
+case 30:
+YY_RULE_SETUP
+#line 95 "firmware/mkcis-lexer.l"
+return RDYBSY;
+	YY_BREAK
+case 31:
+YY_RULE_SETUP
+#line 96 "firmware/mkcis-lexer.l"
+return MWAIT;
+	YY_BREAK
+case 32:
+YY_RULE_SETUP
+#line 97 "firmware/mkcis-lexer.l"
+return AUDIO;
+	YY_BREAK
+case 33:
+YY_RULE_SETUP
+#line 98 "firmware/mkcis-lexer.l"
+return READONLY;
+	YY_BREAK
+case 34:
+YY_RULE_SETUP
+#line 99 "firmware/mkcis-lexer.l"
+return PWRDOWN;
+	YY_BREAK
+case 35:
+YY_RULE_SETUP
+#line 101 "firmware/mkcis-lexer.l"
+return VCC;
+	YY_BREAK
+case 36:
+YY_RULE_SETUP
+#line 102 "firmware/mkcis-lexer.l"
+return VPP1;
+	YY_BREAK
+case 37:
+YY_RULE_SETUP
+#line 103 "firmware/mkcis-lexer.l"
+return VPP2;
+	YY_BREAK
+case 38:
+YY_RULE_SETUP
+#line 104 "firmware/mkcis-lexer.l"
+return VNOM;
+	YY_BREAK
+case 39:
+YY_RULE_SETUP
+#line 105 "firmware/mkcis-lexer.l"
+return VMIN;
+	YY_BREAK
+case 40:
+YY_RULE_SETUP
+#line 106 "firmware/mkcis-lexer.l"
+return VMAX;
+	YY_BREAK
+case 41:
+YY_RULE_SETUP
+#line 107 "firmware/mkcis-lexer.l"
+return ISTATIC;
+	YY_BREAK
+case 42:
+YY_RULE_SETUP
+#line 108 "firmware/mkcis-lexer.l"
+return IAVG;
+	YY_BREAK
+case 43:
+YY_RULE_SETUP
+#line 109 "firmware/mkcis-lexer.l"
+return IPEAK;
+	YY_BREAK
+case 44:
+YY_RULE_SETUP
+#line 110 "firmware/mkcis-lexer.l"
+return IDOWN;
+	YY_BREAK
+case 45:
+YY_RULE_SETUP
+#line 112 "firmware/mkcis-lexer.l"
+return IO;
+	YY_BREAK
+case 46:
+YY_RULE_SETUP
+#line 113 "firmware/mkcis-lexer.l"
+return MEM;
+	YY_BREAK
+case 47:
+YY_RULE_SETUP
+#line 114 "firmware/mkcis-lexer.l"
+return BIT8;
+	YY_BREAK
+case 48:
+YY_RULE_SETUP
+#line 115 "firmware/mkcis-lexer.l"
+return BIT16;
+	YY_BREAK
+case 49:
+YY_RULE_SETUP
+#line 116 "firmware/mkcis-lexer.l"
+return LINES;
+	YY_BREAK
+case 50:
+YY_RULE_SETUP
+#line 117 "firmware/mkcis-lexer.l"
+return RANGE;
+	YY_BREAK
+case 51:
+YY_RULE_SETUP
+#line 119 "firmware/mkcis-lexer.l"
+return IRQ_NO;
+	YY_BREAK
+case 52:
+YY_RULE_SETUP
+#line 120 "firmware/mkcis-lexer.l"
+return LEVEL;
+	YY_BREAK
+case 53:
+YY_RULE_SETUP
+#line 121 "firmware/mkcis-lexer.l"
+return PULSE;
+	YY_BREAK
+case 54:
+YY_RULE_SETUP
+#line 122 "firmware/mkcis-lexer.l"
+return SHARED;
+	YY_BREAK
+case 55:
+YY_RULE_SETUP
+#line 124 "firmware/mkcis-lexer.l"
+return TIMING;
+	YY_BREAK
+case 56:
+YY_RULE_SETUP
+#line 125 "firmware/mkcis-lexer.l"
+return WAIT;
+	YY_BREAK
+case 57:
+YY_RULE_SETUP
+#line 126 "firmware/mkcis-lexer.l"
+return READY;
+	YY_BREAK
+case 58:
+YY_RULE_SETUP
+#line 127 "firmware/mkcis-lexer.l"
+return RESERVED;
+	YY_BREAK
+case 59:
+YY_RULE_SETUP
+#line 129 "firmware/mkcis-lexer.l"
+return lex_number("0");
+	YY_BREAK
+case 60:
+YY_RULE_SETUP
+#line 130 "firmware/mkcis-lexer.l"
+return lex_number("1");
+	YY_BREAK
+case 61:
+YY_RULE_SETUP
+#line 131 "firmware/mkcis-lexer.l"
+return lex_number("2");
+	YY_BREAK
+case 62:
+YY_RULE_SETUP
+#line 132 "firmware/mkcis-lexer.l"
+return lex_number("3");
+	YY_BREAK
+case 63:
+YY_RULE_SETUP
+#line 133 "firmware/mkcis-lexer.l"
+return lex_number("4");
+	YY_BREAK
+case 64:
+YY_RULE_SETUP
+#line 134 "firmware/mkcis-lexer.l"
+return lex_number("5");
+	YY_BREAK
+case 65:
+YY_RULE_SETUP
+#line 135 "firmware/mkcis-lexer.l"
+return lex_number("6");
+	YY_BREAK
+case 66:
+YY_RULE_SETUP
+#line 136 "firmware/mkcis-lexer.l"
+return lex_number("7");
+	YY_BREAK
+case 67:
+YY_RULE_SETUP
+#line 137 "firmware/mkcis-lexer.l"
+return lex_number("8");
+	YY_BREAK
+case 68:
+YY_RULE_SETUP
+#line 139 "firmware/mkcis-lexer.l"
+return lex_number(yytext);
+	YY_BREAK
+case 69:
+YY_RULE_SETUP
+#line 140 "firmware/mkcis-lexer.l"
+return lex_number(yytext);
+	YY_BREAK
+case 70:
+YY_RULE_SETUP
+#line 142 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1, SIZE);
+	YY_BREAK
+case 71:
+YY_RULE_SETUP
+#line 143 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1024, SIZE);
+	YY_BREAK
+case 72:
+YY_RULE_SETUP
+#line 144 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1024*1024, SIZE);
+	YY_BREAK
+case 73:
+YY_RULE_SETUP
+#line 146 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1000000000, TIME);
+	YY_BREAK
+case 74:
+YY_RULE_SETUP
+#line 147 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1000000, TIME);
+	YY_BREAK
+case 75:
+YY_RULE_SETUP
+#line 148 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1000, TIME);
+	YY_BREAK
+case 76:
+YY_RULE_SETUP
+#line 149 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1, TIME);
+	YY_BREAK
+case 77:
+YY_RULE_SETUP
+#line 150 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1000000000, TIME);
+	YY_BREAK
+case 78:
+YY_RULE_SETUP
+#line 151 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1000000, TIME);
+	YY_BREAK
+case 79:
+YY_RULE_SETUP
+#line 152 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1000, TIME);
+	YY_BREAK
+case 80:
+YY_RULE_SETUP
+#line 153 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 1, TIME);
+	YY_BREAK
+case 81:
+YY_RULE_SETUP
+#line 155 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 100000, VOLTAGE);
+	YY_BREAK
+case 82:
+YY_RULE_SETUP
+#line 156 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 100, VOLTAGE);
+	YY_BREAK
+case 83:
+YY_RULE_SETUP
+#line 157 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 0.1, VOLTAGE);
+	YY_BREAK
+case 84:
+YY_RULE_SETUP
+#line 158 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 100000, VOLTAGE);
+	YY_BREAK
+case 85:
+YY_RULE_SETUP
+#line 159 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 100, VOLTAGE);
+	YY_BREAK
+case 86:
+YY_RULE_SETUP
+#line 160 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 0.1, VOLTAGE);
+	YY_BREAK
+case 87:
+YY_RULE_SETUP
+#line 162 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 10000000, CURRENT);
+	YY_BREAK
+case 88:
+YY_RULE_SETUP
+#line 163 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 10000, CURRENT);
+	YY_BREAK
+case 89:
+YY_RULE_SETUP
+#line 164 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 10, CURRENT);
+	YY_BREAK
+case 90:
+YY_RULE_SETUP
+#line 165 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 10000000, CURRENT);
+	YY_BREAK
+case 91:
+YY_RULE_SETUP
+#line 166 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 10000, CURRENT);
+	YY_BREAK
+case 92:
+YY_RULE_SETUP
+#line 167 "firmware/mkcis-lexer.l"
+return lex_units(yytext, 10, CURRENT);
+	YY_BREAK
+case 93:
+YY_RULE_SETUP
+#line 169 "firmware/mkcis-lexer.l"
+return lex_float(yytext);
+	YY_BREAK
+case 94:
+/* rule 94 can match eol */
+YY_RULE_SETUP
+#line 171 "firmware/mkcis-lexer.l"
+return lex_string(yytext);
+	YY_BREAK
+case 95:
+YY_RULE_SETUP
+#line 173 "firmware/mkcis-lexer.l"
+return yytext[0];
+	YY_BREAK
+case 96:
+YY_RULE_SETUP
+#line 175 "firmware/mkcis-lexer.l"
+ECHO;
+	YY_BREAK
+#line 1531 "firmware/mkcis-lexer.lex.c"
+case YY_STATE_EOF(INITIAL):
+	yyterminate();
+
+	case YY_END_OF_BUFFER:
+		{
+		/* Amount of text matched not including the EOB char. */
+		int yy_amount_of_matched_text = (int) (yy_cp - (yytext_ptr)) - 1;
+
+		/* Undo the effects of YY_DO_BEFORE_ACTION. */
+		*yy_cp = (yy_hold_char);
+		YY_RESTORE_YY_MORE_OFFSET
+
+		if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_NEW )
+			{
+			/* We're scanning a new file or input source.  It's
+			 * possible that this happened because the user
+			 * just pointed yyin at a new source and called
+			 * yylex().  If so, then we have to assure
+			 * consistency between YY_CURRENT_BUFFER and our
+			 * globals.  Here is the right place to do so, because
+			 * this is the first action (other than possibly a
+			 * back-up) that will match for the new input source.
+			 */
+			(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
+			YY_CURRENT_BUFFER_LVALUE->yy_input_file = yyin;
+			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status = YY_BUFFER_NORMAL;
+			}
+
+		/* Note that here we test for yy_c_buf_p "<=" to the position
+		 * of the first EOB in the buffer, since yy_c_buf_p will
+		 * already have been incremented past the NUL character
+		 * (since all states make transitions on EOB to the
+		 * end-of-buffer state).  Contrast this with the test
+		 * in input().
+		 */
+		if ( (yy_c_buf_p) <= &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] )
+			{ /* This was really a NUL. */
+			yy_state_type yy_next_state;
+
+			(yy_c_buf_p) = (yytext_ptr) + yy_amount_of_matched_text;
+
+			yy_current_state = yy_get_previous_state(  );
+
+			/* Okay, we're now positioned to make the NUL
+			 * transition.  We couldn't have
+			 * yy_get_previous_state() go ahead and do it
+			 * for us because it doesn't know how to deal
+			 * with the possibility of jamming (and we don't
+			 * want to build jamming into it because then it
+			 * will run more slowly).
+			 */
+
+			yy_next_state = yy_try_NUL_trans( yy_current_state );
+
+			yy_bp = (yytext_ptr) + YY_MORE_ADJ;
+
+			if ( yy_next_state )
+				{
+				/* Consume the NUL. */
+				yy_cp = ++(yy_c_buf_p);
+				yy_current_state = yy_next_state;
+				goto yy_match;
+				}
+
+			else
+				{
+				yy_cp = (yy_c_buf_p);
+				goto yy_find_action;
+				}
+			}
+
+		else switch ( yy_get_next_buffer(  ) )
+			{
+			case EOB_ACT_END_OF_FILE:
+				{
+				(yy_did_buffer_switch_on_eof) = 0;
+
+				if ( yywrap( ) )
+					{
+					/* Note: because we've taken care in
+					 * yy_get_next_buffer() to have set up
+					 * yytext, we can now set up
+					 * yy_c_buf_p so that if some total
+					 * hoser (like flex itself) wants to
+					 * call the scanner after we return the
+					 * YY_NULL, it'll still work - another
+					 * YY_NULL will get returned.
+					 */
+					(yy_c_buf_p) = (yytext_ptr) + YY_MORE_ADJ;
+
+					yy_act = YY_STATE_EOF(YY_START);
+					goto do_action;
+					}
+
+				else
+					{
+					if ( ! (yy_did_buffer_switch_on_eof) )
+						YY_NEW_FILE;
+					}
+				break;
+				}
+
+			case EOB_ACT_CONTINUE_SCAN:
+				(yy_c_buf_p) =
+					(yytext_ptr) + yy_amount_of_matched_text;
+
+				yy_current_state = yy_get_previous_state(  );
+
+				yy_cp = (yy_c_buf_p);
+				yy_bp = (yytext_ptr) + YY_MORE_ADJ;
+				goto yy_match;
+
+			case EOB_ACT_LAST_MATCH:
+				(yy_c_buf_p) =
+				&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)];
+
+				yy_current_state = yy_get_previous_state(  );
+
+				yy_cp = (yy_c_buf_p);
+				yy_bp = (yytext_ptr) + YY_MORE_ADJ;
+				goto yy_find_action;
+			}
+		break;
+		}
+
+	default:
+		YY_FATAL_ERROR(
+			"fatal flex scanner internal error--no action found" );
+	} /* end of action switch */
+		} /* end of scanning one token */
+} /* end of yylex */
+
+/* yy_get_next_buffer - try to read in a new buffer
+ *
+ * Returns a code representing an action:
+ *	EOB_ACT_LAST_MATCH -
+ *	EOB_ACT_CONTINUE_SCAN - continue scanning from current position
+ *	EOB_ACT_END_OF_FILE - end of file
+ */
+static int yy_get_next_buffer (void)
+{
+    	register char *dest = YY_CURRENT_BUFFER_LVALUE->yy_ch_buf;
+	register char *source = (yytext_ptr);
+	register int number_to_move, i;
+	int ret_val;
+
+	if ( (yy_c_buf_p) > &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars) + 1] )
+		YY_FATAL_ERROR(
+		"fatal flex scanner internal error--end of buffer missed" );
+
+	if ( YY_CURRENT_BUFFER_LVALUE->yy_fill_buffer == 0 )
+		{ /* Don't try to fill the buffer, so this is an EOF. */
+		if ( (yy_c_buf_p) - (yytext_ptr) - YY_MORE_ADJ == 1 )
+			{
+			/* We matched a single character, the EOB, so
+			 * treat this as a final EOF.
+			 */
+			return EOB_ACT_END_OF_FILE;
+			}
+
+		else
+			{
+			/* We matched some text prior to the EOB, first
+			 * process it.
+			 */
+			return EOB_ACT_LAST_MATCH;
+			}
+		}
+
+	/* Try to read more data. */
+
+	/* First move last chars to start of buffer. */
+	number_to_move = (int) ((yy_c_buf_p) - (yytext_ptr)) - 1;
+
+	for ( i = 0; i < number_to_move; ++i )
+		*(dest++) = *(source++);
+
+	if ( YY_CURRENT_BUFFER_LVALUE->yy_buffer_status == YY_BUFFER_EOF_PENDING )
+		/* don't do the read, it's not guaranteed to return an EOF,
+		 * just force an EOF
+		 */
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars) = 0;
+
+	else
+		{
+			int num_to_read =
+			YY_CURRENT_BUFFER_LVALUE->yy_buf_size - number_to_move - 1;
+
+		while ( num_to_read <= 0 )
+			{ /* Not enough room in the buffer - grow it. */
+
+			/* just a shorter name for the current buffer */
+			YY_BUFFER_STATE b = YY_CURRENT_BUFFER;
+
+			int yy_c_buf_p_offset =
+				(int) ((yy_c_buf_p) - b->yy_ch_buf);
+
+			if ( b->yy_is_our_buffer )
+				{
+				int new_size = b->yy_buf_size * 2;
+
+				if ( new_size <= 0 )
+					b->yy_buf_size += b->yy_buf_size / 8;
+				else
+					b->yy_buf_size *= 2;
+
+				b->yy_ch_buf = (char *)
+					/* Include room in for 2 EOB chars. */
+					yyrealloc((void *) b->yy_ch_buf,b->yy_buf_size + 2  );
+				}
+			else
+				/* Can't grow it, we don't own it. */
+				b->yy_ch_buf = 0;
+
+			if ( ! b->yy_ch_buf )
+				YY_FATAL_ERROR(
+				"fatal error - scanner input buffer overflow" );
+
+			(yy_c_buf_p) = &b->yy_ch_buf[yy_c_buf_p_offset];
+
+			num_to_read = YY_CURRENT_BUFFER_LVALUE->yy_buf_size -
+						number_to_move - 1;
+
+			}
+
+		if ( num_to_read > YY_READ_BUF_SIZE )
+			num_to_read = YY_READ_BUF_SIZE;
+
+		/* Read in more data. */
+		YY_INPUT( (&YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[number_to_move]),
+			(yy_n_chars), (size_t) num_to_read );
+
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
+		}
+
+	if ( (yy_n_chars) == 0 )
+		{
+		if ( number_to_move == YY_MORE_ADJ )
+			{
+			ret_val = EOB_ACT_END_OF_FILE;
+			yyrestart(yyin  );
+			}
+
+		else
+			{
+			ret_val = EOB_ACT_LAST_MATCH;
+			YY_CURRENT_BUFFER_LVALUE->yy_buffer_status =
+				YY_BUFFER_EOF_PENDING;
+			}
+		}
+
+	else
+		ret_val = EOB_ACT_CONTINUE_SCAN;
+
+	if ((yy_size_t) ((yy_n_chars) + number_to_move) > YY_CURRENT_BUFFER_LVALUE->yy_buf_size) {
+		/* Extend the array by 50%, plus the number we really need. */
+		yy_size_t new_size = (yy_n_chars) + number_to_move + ((yy_n_chars) >> 1);
+		YY_CURRENT_BUFFER_LVALUE->yy_ch_buf = (char *) yyrealloc((void *) YY_CURRENT_BUFFER_LVALUE->yy_ch_buf,new_size  );
+		if ( ! YY_CURRENT_BUFFER_LVALUE->yy_ch_buf )
+			YY_FATAL_ERROR( "out of dynamic memory in yy_get_next_buffer()" );
+	}
+
+	(yy_n_chars) += number_to_move;
+	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] = YY_END_OF_BUFFER_CHAR;
+	YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars) + 1] = YY_END_OF_BUFFER_CHAR;
+
+	(yytext_ptr) = &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[0];
+
+	return ret_val;
+}
+
+/* yy_get_previous_state - get the state just before the EOB char was reached */
+
+    static yy_state_type yy_get_previous_state (void)
+{
+	register yy_state_type yy_current_state;
+	register char *yy_cp;
+    
+	yy_current_state = (yy_start);
+
+	for ( yy_cp = (yytext_ptr) + YY_MORE_ADJ; yy_cp < (yy_c_buf_p); ++yy_cp )
+		{
+		register YY_CHAR yy_c = (*yy_cp ? yy_ec[YY_SC_TO_UI(*yy_cp)] : 1);
+		if ( yy_accept[yy_current_state] )
+			{
+			(yy_last_accepting_state) = yy_current_state;
+			(yy_last_accepting_cpos) = yy_cp;
+			}
+		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
+			{
+			yy_current_state = (int) yy_def[yy_current_state];
+			if ( yy_current_state >= 442 )
+				yy_c = yy_meta[(unsigned int) yy_c];
+			}
+		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+		}
+
+	return yy_current_state;
+}
+
+/* yy_try_NUL_trans - try to make a transition on the NUL character
+ *
+ * synopsis
+ *	next_state = yy_try_NUL_trans( current_state );
+ */
+    static yy_state_type yy_try_NUL_trans  (yy_state_type yy_current_state )
+{
+	register int yy_is_jam;
+    	register char *yy_cp = (yy_c_buf_p);
+
+	register YY_CHAR yy_c = 1;
+	if ( yy_accept[yy_current_state] )
+		{
+		(yy_last_accepting_state) = yy_current_state;
+		(yy_last_accepting_cpos) = yy_cp;
+		}
+	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
+		{
+		yy_current_state = (int) yy_def[yy_current_state];
+		if ( yy_current_state >= 442 )
+			yy_c = yy_meta[(unsigned int) yy_c];
+		}
+	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
+	yy_is_jam = (yy_current_state == 441);
+
+	return yy_is_jam ? 0 : yy_current_state;
+}
+
+#ifndef YY_NO_INPUT
+#ifdef __cplusplus
+    static int yyinput (void)
+#else
+    static int input  (void)
+#endif
+
+{
+	int c;
+    
+	*(yy_c_buf_p) = (yy_hold_char);
+
+	if ( *(yy_c_buf_p) == YY_END_OF_BUFFER_CHAR )
+		{
+		/* yy_c_buf_p now points to the character we want to return.
+		 * If this occurs *before* the EOB characters, then it's a
+		 * valid NUL; if not, then we've hit the end of the buffer.
+		 */
+		if ( (yy_c_buf_p) < &YY_CURRENT_BUFFER_LVALUE->yy_ch_buf[(yy_n_chars)] )
+			/* This was really a NUL. */
+			*(yy_c_buf_p) = '\0';
+
+		else
+			{ /* need more input */
+			int offset = (yy_c_buf_p) - (yytext_ptr);
+			++(yy_c_buf_p);
+
+			switch ( yy_get_next_buffer(  ) )
+				{
+				case EOB_ACT_LAST_MATCH:
+					/* This happens because yy_g_n_b()
+					 * sees that we've accumulated a
+					 * token and flags that we need to
+					 * try matching the token before
+					 * proceeding.  But for input(),
+					 * there's no matching to consider.
+					 * So convert the EOB_ACT_LAST_MATCH
+					 * to EOB_ACT_END_OF_FILE.
+					 */
+
+					/* Reset buffer status. */
+					yyrestart(yyin );
+
+					/*FALLTHROUGH*/
+
+				case EOB_ACT_END_OF_FILE:
+					{
+					if ( yywrap( ) )
+						return EOF;
+
+					if ( ! (yy_did_buffer_switch_on_eof) )
+						YY_NEW_FILE;
+#ifdef __cplusplus
+					return yyinput();
+#else
+					return input();
+#endif
+					}
+
+				case EOB_ACT_CONTINUE_SCAN:
+					(yy_c_buf_p) = (yytext_ptr) + offset;
+					break;
+				}
+			}
+		}
+
+	c = *(unsigned char *) (yy_c_buf_p);	/* cast for 8-bit char's */
+	*(yy_c_buf_p) = '\0';	/* preserve yytext */
+	(yy_hold_char) = *++(yy_c_buf_p);
+
+	return c;
+}
+#endif	/* ifndef YY_NO_INPUT */
+
+/** Immediately switch to a different input stream.
+ * @param input_file A readable stream.
+ * 
+ * @note This function does not reset the start condition to @c INITIAL .
+ */
+    void yyrestart  (FILE * input_file )
+{
+    
+	if ( ! YY_CURRENT_BUFFER ){
+        yyensure_buffer_stack ();
+		YY_CURRENT_BUFFER_LVALUE =
+            yy_create_buffer(yyin,YY_BUF_SIZE );
+	}
+
+	yy_init_buffer(YY_CURRENT_BUFFER,input_file );
+	yy_load_buffer_state( );
+}
+
+/** Switch to a different input buffer.
+ * @param new_buffer The new input buffer.
+ * 
+ */
+    void yy_switch_to_buffer  (YY_BUFFER_STATE  new_buffer )
+{
+    
+	/* TODO. We should be able to replace this entire function body
+	 * with
+	 *		yypop_buffer_state();
+	 *		yypush_buffer_state(new_buffer);
+     */
+	yyensure_buffer_stack ();
+	if ( YY_CURRENT_BUFFER == new_buffer )
+		return;
+
+	if ( YY_CURRENT_BUFFER )
+		{
+		/* Flush out information for old buffer. */
+		*(yy_c_buf_p) = (yy_hold_char);
+		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = (yy_c_buf_p);
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
+		}
+
+	YY_CURRENT_BUFFER_LVALUE = new_buffer;
+	yy_load_buffer_state( );
+
+	/* We don't actually know whether we did this switch during
+	 * EOF (yywrap()) processing, but the only time this flag
+	 * is looked at is after yywrap() is called, so it's safe
+	 * to go ahead and always set it.
+	 */
+	(yy_did_buffer_switch_on_eof) = 1;
+}
+
+static void yy_load_buffer_state  (void)
+{
+    	(yy_n_chars) = YY_CURRENT_BUFFER_LVALUE->yy_n_chars;
+	(yytext_ptr) = (yy_c_buf_p) = YY_CURRENT_BUFFER_LVALUE->yy_buf_pos;
+	yyin = YY_CURRENT_BUFFER_LVALUE->yy_input_file;
+	(yy_hold_char) = *(yy_c_buf_p);
+}
+
+/** Allocate and initialize an input buffer state.
+ * @param file A readable stream.
+ * @param size The character buffer size in bytes. When in doubt, use @c YY_BUF_SIZE.
+ * 
+ * @return the allocated buffer state.
+ */
+    YY_BUFFER_STATE yy_create_buffer  (FILE * file, int  size )
+{
+	YY_BUFFER_STATE b;
+    
+	b = (YY_BUFFER_STATE) yyalloc(sizeof( struct yy_buffer_state )  );
+	if ( ! b )
+		YY_FATAL_ERROR( "out of dynamic memory in yy_create_buffer()" );
+
+	b->yy_buf_size = size;
+
+	/* yy_ch_buf has to be 2 characters longer than the size given because
+	 * we need to put in 2 end-of-buffer characters.
+	 */
+	b->yy_ch_buf = (char *) yyalloc(b->yy_buf_size + 2  );
+	if ( ! b->yy_ch_buf )
+		YY_FATAL_ERROR( "out of dynamic memory in yy_create_buffer()" );
+
+	b->yy_is_our_buffer = 1;
+
+	yy_init_buffer(b,file );
+
+	return b;
+}
+
+/** Destroy the buffer.
+ * @param b a buffer created with yy_create_buffer()
+ * 
+ */
+    void yy_delete_buffer (YY_BUFFER_STATE  b )
+{
+    
+	if ( ! b )
+		return;
+
+	if ( b == YY_CURRENT_BUFFER ) /* Not sure if we should pop here. */
+		YY_CURRENT_BUFFER_LVALUE = (YY_BUFFER_STATE) 0;
+
+	if ( b->yy_is_our_buffer )
+		yyfree((void *) b->yy_ch_buf  );
+
+	yyfree((void *) b  );
+}
+
+#ifndef __cplusplus
+extern int isatty (int );
+#endif /* __cplusplus */
+    
+/* Initializes or reinitializes a buffer.
+ * This function is sometimes called more than once on the same buffer,
+ * such as during a yyrestart() or at EOF.
+ */
+    static void yy_init_buffer  (YY_BUFFER_STATE  b, FILE * file )
+
+{
+	int oerrno = errno;
+    
+	yy_flush_buffer(b );
+
+	b->yy_input_file = file;
+	b->yy_fill_buffer = 1;
+
+    /* If b is the current buffer, then yy_init_buffer was _probably_
+     * called from yyrestart() or through yy_get_next_buffer.
+     * In that case, we don't want to reset the lineno or column.
+     */
+    if (b != YY_CURRENT_BUFFER){
+        b->yy_bs_lineno = 1;
+        b->yy_bs_column = 0;
+    }
+
+        b->yy_is_interactive = file ? (isatty( fileno(file) ) > 0) : 0;
+    
+	errno = oerrno;
+}
+
+/** Discard all buffered characters. On the next scan, YY_INPUT will be called.
+ * @param b the buffer state to be flushed, usually @c YY_CURRENT_BUFFER.
+ * 
+ */
+    void yy_flush_buffer (YY_BUFFER_STATE  b )
+{
+    	if ( ! b )
+		return;
+
+	b->yy_n_chars = 0;
+
+	/* We always need two end-of-buffer characters.  The first causes
+	 * a transition to the end-of-buffer state.  The second causes
+	 * a jam in that state.
+	 */
+	b->yy_ch_buf[0] = YY_END_OF_BUFFER_CHAR;
+	b->yy_ch_buf[1] = YY_END_OF_BUFFER_CHAR;
+
+	b->yy_buf_pos = &b->yy_ch_buf[0];
+
+	b->yy_at_bol = 1;
+	b->yy_buffer_status = YY_BUFFER_NEW;
+
+	if ( b == YY_CURRENT_BUFFER )
+		yy_load_buffer_state( );
+}
+
+/** Pushes the new state onto the stack. The new state becomes
+ *  the current state. This function will allocate the stack
+ *  if necessary.
+ *  @param new_buffer The new state.
+ *  
+ */
+void yypush_buffer_state (YY_BUFFER_STATE new_buffer )
+{
+    	if (new_buffer == NULL)
+		return;
+
+	yyensure_buffer_stack();
+
+	/* This block is copied from yy_switch_to_buffer. */
+	if ( YY_CURRENT_BUFFER )
+		{
+		/* Flush out information for old buffer. */
+		*(yy_c_buf_p) = (yy_hold_char);
+		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = (yy_c_buf_p);
+		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = (yy_n_chars);
+		}
+
+	/* Only push if top exists. Otherwise, replace top. */
+	if (YY_CURRENT_BUFFER)
+		(yy_buffer_stack_top)++;
+	YY_CURRENT_BUFFER_LVALUE = new_buffer;
+
+	/* copied from yy_switch_to_buffer. */
+	yy_load_buffer_state( );
+	(yy_did_buffer_switch_on_eof) = 1;
+}
+
+/** Removes and deletes the top of the stack, if present.
+ *  The next element becomes the new top.
+ *  
+ */
+void yypop_buffer_state (void)
+{
+    	if (!YY_CURRENT_BUFFER)
+		return;
+
+	yy_delete_buffer(YY_CURRENT_BUFFER );
+	YY_CURRENT_BUFFER_LVALUE = NULL;
+	if ((yy_buffer_stack_top) > 0)
+		--(yy_buffer_stack_top);
+
+	if (YY_CURRENT_BUFFER) {
+		yy_load_buffer_state( );
+		(yy_did_buffer_switch_on_eof) = 1;
+	}
+}
+
+/* Allocates the stack if it does not exist.
+ *  Guarantees space for at least one push.
+ */
+static void yyensure_buffer_stack (void)
+{
+	int num_to_alloc;
+    
+	if (!(yy_buffer_stack)) {
+
+		/* First allocation is just for 2 elements, since we don't know if this
+		 * scanner will even need a stack. We use 2 instead of 1 to avoid an
+		 * immediate realloc on the next call.
+         */
+		num_to_alloc = 1;
+		(yy_buffer_stack) = (struct yy_buffer_state**)yyalloc
+								(num_to_alloc * sizeof(struct yy_buffer_state*)
+								);
+		if ( ! (yy_buffer_stack) )
+			YY_FATAL_ERROR( "out of dynamic memory in yyensure_buffer_stack()" );
+								  
+		memset((yy_buffer_stack), 0, num_to_alloc * sizeof(struct yy_buffer_state*));
+				
+		(yy_buffer_stack_max) = num_to_alloc;
+		(yy_buffer_stack_top) = 0;
+		return;
+	}
+
+	if ((yy_buffer_stack_top) >= ((yy_buffer_stack_max)) - 1){
+
+		/* Increase the buffer to prepare for a possible push. */
+		int grow_size = 8 /* arbitrary grow size */;
+
+		num_to_alloc = (yy_buffer_stack_max) + grow_size;
+		(yy_buffer_stack) = (struct yy_buffer_state**)yyrealloc
+								((yy_buffer_stack),
+								num_to_alloc * sizeof(struct yy_buffer_state*)
+								);
+		if ( ! (yy_buffer_stack) )
+			YY_FATAL_ERROR( "out of dynamic memory in yyensure_buffer_stack()" );
+
+		/* zero only the new slots.*/
+		memset((yy_buffer_stack) + (yy_buffer_stack_max), 0, grow_size * sizeof(struct yy_buffer_state*));
+		(yy_buffer_stack_max) = num_to_alloc;
+	}
+}
+
+/** Setup the input buffer state to scan directly from a user-specified character buffer.
+ * @param base the character buffer
+ * @param size the size in bytes of the character buffer
+ * 
+ * @return the newly allocated buffer state object. 
+ */
+YY_BUFFER_STATE yy_scan_buffer  (char * base, yy_size_t  size )
+{
+	YY_BUFFER_STATE b;
+    
+	if ( size < 2 ||
+	     base[size-2] != YY_END_OF_BUFFER_CHAR ||
+	     base[size-1] != YY_END_OF_BUFFER_CHAR )
+		/* They forgot to leave room for the EOB's. */
+		return 0;
+
+	b = (YY_BUFFER_STATE) yyalloc(sizeof( struct yy_buffer_state )  );
+	if ( ! b )
+		YY_FATAL_ERROR( "out of dynamic memory in yy_scan_buffer()" );
+
+	b->yy_buf_size = size - 2;	/* "- 2" to take care of EOB's */
+	b->yy_buf_pos = b->yy_ch_buf = base;
+	b->yy_is_our_buffer = 0;
+	b->yy_input_file = 0;
+	b->yy_n_chars = b->yy_buf_size;
+	b->yy_is_interactive = 0;
+	b->yy_at_bol = 1;
+	b->yy_fill_buffer = 0;
+	b->yy_buffer_status = YY_BUFFER_NEW;
+
+	yy_switch_to_buffer(b  );
+
+	return b;
+}
+
+/** Setup the input buffer state to scan a string. The next call to yylex() will
+ * scan from a @e copy of @a str.
+ * @param yystr a NUL-terminated string to scan
+ * 
+ * @return the newly allocated buffer state object.
+ * @note If you want to scan bytes that may contain NUL values, then use
+ *       yy_scan_bytes() instead.
+ */
+YY_BUFFER_STATE yy_scan_string (yyconst char * yystr )
+{
+    
+	return yy_scan_bytes(yystr,strlen(yystr) );
+}
+
+/** Setup the input buffer state to scan the given bytes. The next call to yylex() will
+ * scan from a @e copy of @a bytes.
+ * @param yybytes the byte buffer to scan
+ * @param _yybytes_len the number of bytes in the buffer pointed to by @a bytes.
+ * 
+ * @return the newly allocated buffer state object.
+ */
+YY_BUFFER_STATE yy_scan_bytes  (yyconst char * yybytes, int  _yybytes_len )
+{
+	YY_BUFFER_STATE b;
+	char *buf;
+	yy_size_t n;
+	int i;
+    
+	/* Get memory for full buffer, including space for trailing EOB's. */
+	n = _yybytes_len + 2;
+	buf = (char *) yyalloc(n  );
+	if ( ! buf )
+		YY_FATAL_ERROR( "out of dynamic memory in yy_scan_bytes()" );
+
+	for ( i = 0; i < _yybytes_len; ++i )
+		buf[i] = yybytes[i];
+
+	buf[_yybytes_len] = buf[_yybytes_len+1] = YY_END_OF_BUFFER_CHAR;
+
+	b = yy_scan_buffer(buf,n );
+	if ( ! b )
+		YY_FATAL_ERROR( "bad buffer in yy_scan_bytes()" );
+
+	/* It's okay to grow etc. this buffer, and we should throw it
+	 * away when we're done.
+	 */
+	b->yy_is_our_buffer = 1;
+
+	return b;
+}
+
+#ifndef YY_EXIT_FAILURE
+#define YY_EXIT_FAILURE 2
+#endif
+
+static void yy_fatal_error (yyconst char* msg )
+{
+    	(void) fprintf( stderr, "%s\n", msg );
+	exit( YY_EXIT_FAILURE );
+}
+
+/* Redefine yyless() so it works in section 3 code. */
+
+#undef yyless
+#define yyless(n) \
+	do \
+		{ \
+		/* Undo effects of setting up yytext. */ \
+        int yyless_macro_arg = (n); \
+        YY_LESS_LINENO(yyless_macro_arg);\
+		yytext[yyleng] = (yy_hold_char); \
+		(yy_c_buf_p) = yytext + yyless_macro_arg; \
+		(yy_hold_char) = *(yy_c_buf_p); \
+		*(yy_c_buf_p) = '\0'; \
+		yyleng = yyless_macro_arg; \
+		} \
+	while ( 0 )
+
+/* Accessor  methods (get/set functions) to struct members. */
+
+/** Get the current line number.
+ * 
+ */
+int yyget_lineno  (void)
+{
+        
+    return yylineno;
+}
+
+/** Get the input stream.
+ * 
+ */
+FILE *yyget_in  (void)
+{
+        return yyin;
+}
+
+/** Get the output stream.
+ * 
+ */
+FILE *yyget_out  (void)
+{
+        return yyout;
+}
+
+/** Get the length of the current token.
+ * 
+ */
+int yyget_leng  (void)
+{
+        return yyleng;
+}
+
+/** Get the current token.
+ * 
+ */
+
+char *yyget_text  (void)
+{
+        return yytext;
+}
+
+/** Set the current line number.
+ * @param line_number
+ * 
+ */
+void yyset_lineno (int  line_number )
+{
+    
+    yylineno = line_number;
+}
+
+/** Set the input stream. This does not discard the current
+ * input buffer.
+ * @param in_str A readable stream.
+ * 
+ * @see yy_switch_to_buffer
+ */
+void yyset_in (FILE *  in_str )
+{
+        yyin = in_str ;
+}
+
+void yyset_out (FILE *  out_str )
+{
+        yyout = out_str ;
+}
+
+int yyget_debug  (void)
+{
+        return yy_flex_debug;
+}
+
+void yyset_debug (int  bdebug )
+{
+        yy_flex_debug = bdebug ;
+}
+
+static int yy_init_globals (void)
+{
+        /* Initialization is the same as for the non-reentrant scanner.
+     * This function is called from yylex_destroy(), so don't allocate here.
+     */
+
+    (yy_buffer_stack) = 0;
+    (yy_buffer_stack_top) = 0;
+    (yy_buffer_stack_max) = 0;
+    (yy_c_buf_p) = (char *) 0;
+    (yy_init) = 0;
+    (yy_start) = 0;
+
+/* Defined in main.c */
+#ifdef YY_STDINIT
+    yyin = stdin;
+    yyout = stdout;
+#else
+    yyin = (FILE *) 0;
+    yyout = (FILE *) 0;
+#endif
+
+    /* For future reference: Set errno on error, since we are called by
+     * yylex_init()
+     */
+    return 0;
+}
+
+/* yylex_destroy is for both reentrant and non-reentrant scanners. */
+int yylex_destroy  (void)
+{
+    
+    /* Pop the buffer stack, destroying each element. */
+	while(YY_CURRENT_BUFFER){
+		yy_delete_buffer(YY_CURRENT_BUFFER  );
+		YY_CURRENT_BUFFER_LVALUE = NULL;
+		yypop_buffer_state();
+	}
+
+	/* Destroy the stack itself. */
+	yyfree((yy_buffer_stack) );
+	(yy_buffer_stack) = NULL;
+
+    /* Reset the globals. This is important in a non-reentrant scanner so the next time
+     * yylex() is called, initialization will occur. */
+    yy_init_globals( );
+
+    return 0;
+}
+
+/*
+ * Internal utility routines.
+ */
+
+#ifndef yytext_ptr
+static void yy_flex_strncpy (char* s1, yyconst char * s2, int n )
+{
+	register int i;
+	for ( i = 0; i < n; ++i )
+		s1[i] = s2[i];
+}
+#endif
+
+#ifdef YY_NEED_STRLEN
+static int yy_flex_strlen (yyconst char * s )
+{
+	register int n;
+	for ( n = 0; s[n]; ++n )
+		;
+
+	return n;
+}
+#endif
+
+void *yyalloc (yy_size_t  size )
+{
+	return (void *) malloc( size );
+}
+
+void *yyrealloc  (void * ptr, yy_size_t  size )
+{
+	/* The cast to (char *) in the following accommodates both
+	 * implementations that use char* generic pointers, and those
+	 * that use void* generic pointers.  It works with the latter
+	 * because both ANSI C and C++ allow castless assignment from
+	 * any pointer type to void*, and deal with argument conversions
+	 * as though doing an assignment.
+	 */
+	return (void *) realloc( (char *) ptr, size );
+}
+
+void yyfree (void * ptr )
+{
+	free( (char *) ptr );	/* see yyrealloc() for (char *) cast */
+}
+
+#define YYTABLES_NAME "yytables"
+
+#line 175 "firmware/mkcis-lexer.l"
+
+
+
+#ifndef yywrap
+int yywrap() { return 1; }
+#endif
+
+/*======================================================================
+
+    Stuff to parse basic data types
+
+======================================================================*/
+
+static int lex_number(char *s)
+{
+    yylval.num = strtoul(s, NULL, 0);
+    return NUMBER;
+}
+
+static int lex_float(char *s)
+{
+    yylval.flt = strtod(s, NULL);
+    return FLOAT;
+}
+
+static int lex_units(char *s, int scale, int token)
+{
+    float f;
+    sscanf(s, "%f", &f);
+    yylval.num = scale*f + 0.5;
+    return token;
+}
+
+static int lex_string(char *s)
+{
+    int n = strlen(s);
+    yylval.str = malloc(n-1);
+    strncpy(yylval.str, s+1, n-2);
+    yylval.str[n-2] = '\0';
+    return STRING;
+}
+
+/*======================================================================
+
+    The main parser entry point
+
+======================================================================*/
+
+void parse_cis(FILE *f)
+{
+    current_lineno = 1;
+    yyrestart(f);
+    yyparse();
+}
+
+
diff --git a/mkcis/mkcis-parser.tab.c b/mkcis/mkcis-parser.tab.c
new file mode 100644
index 0000000..4b11702
--- /dev/null
+++ b/mkcis/mkcis-parser.tab.c
@@ -0,0 +1,2338 @@
+
+/* A Bison parser, made by GNU Bison 2.4.1.  */
+
+/* Skeleton implementation for Bison's Yacc-like parsers in C
+   
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+   Free Software Foundation, Inc.
+   
+   This program is free software: you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation, either version 3 of the License, or
+   (at your option) any later version.
+   
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+   
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+/* As a special exception, you may create a larger work that contains
+   part or all of the Bison parser skeleton and distribute that work
+   under terms of your choice, so long as that work isn't itself a
+   parser generator using the skeleton or a modified version thereof
+   as a parser skeleton.  Alternatively, if you modify or redistribute
+   the parser skeleton itself, you may (at your option) remove this
+   special exception, which will cause the skeleton and the resulting
+   Bison output files to be licensed under the GNU General Public
+   License without this special exception.
+   
+   This special exception was added by the Free Software Foundation in
+   version 2.2 of Bison.  */
+
+/* C LALR(1) parser skeleton written by Richard Stallman, by
+   simplifying the original so-called "semantic" parser.  */
+
+/* All symbols defined below should begin with yy or YY, to avoid
+   infringing on user name space.  This should be done even for local
+   variables, as they might otherwise be expanded by user macros.
+   There are some unavoidable exceptions within include files to
+   define necessary library symbols; they are noted "INFRINGES ON
+   USER NAME SPACE" below.  */
+
+/* Identify Bison output.  */
+#define YYBISON 1
+
+/* Bison version.  */
+#define YYBISON_VERSION "2.4.1"
+
+/* Skeleton name.  */
+#define YYSKELETON_NAME "yacc.c"
+
+/* Pure parsers.  */
+#define YYPURE 0
+
+/* Push parsers.  */
+#define YYPUSH 0
+
+/* Pull parsers.  */
+#define YYPULL 1
+
+/* Using locations.  */
+#define YYLSP_NEEDED 0
+
+
+
+/* Copy the first part of user declarations.  */
+
+/* Line 189 of yacc.c  */
+#line 1 "mkcis-parser.y"
+
+/*
+ * yacc_cis.y 1.11 2000/06/12 21:34:19
+ *
+ * The contents of this file are subject to the Mozilla Public License
+ * Version 1.1 (the "License"); you may not use this file except in
+ * compliance with the License. You may obtain a copy of the License
+ * at http://www.mozilla.org/MPL/
+ *
+ * Software distributed under the License is distributed on an "AS IS"
+ * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
+ * the License for the specific language governing rights and
+ * limitations under the License.
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * Alternatively, the contents of this file may be used under the
+ * terms of the GNU Public License version 2 (the "GPL"), in which
+ * case the provisions of the GPL are applicable instead of the
+ * above.  If you wish to allow the use of your version of this file
+ * only under the terms of the GPL and not to allow others to use
+ * your version of this file under the MPL, indicate your decision by
+ * deleting the provisions above and replace them with the notice and
+ * other provisions required by the GPL.  If you do not delete the
+ * provisions above, a recipient may use your version of this file
+ * under either the MPL or the GPL.
+ */
+
+#include <sys/types.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdarg.h>
+#include <math.h>
+
+#include <cistpl.h>
+
+#include "mkcis.h"
+
+/* If bison: generate nicer error messages */
+#define YYERROR_VERBOSE 1
+
+void yyerror(char *msg, ...);
+static tuple_info_t *new_tuple(u_char type, cisparse_t *parse);
+
+
+
+/* Line 189 of yacc.c  */
+#line 123 "mkcis-parser.tab.c"
+
+/* Enabling traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 0
+#endif
+
+/* Enabling verbose error messages.  */
+#ifdef YYERROR_VERBOSE
+# undef YYERROR_VERBOSE
+# define YYERROR_VERBOSE 1
+#else
+# define YYERROR_VERBOSE 0
+#endif
+
+/* Enabling the token table.  */
+#ifndef YYTOKEN_TABLE
+# define YYTOKEN_TABLE 0
+#endif
+
+
+/* Tokens.  */
+#ifndef YYTOKENTYPE
+# define YYTOKENTYPE
+   /* Put the tokens into the symbol table, so that GDB and other debuggers
+      know about them.  */
+   enum yytokentype {
+     STRING = 258,
+     NUMBER = 259,
+     FLOAT = 260,
+     VOLTAGE = 261,
+     CURRENT = 262,
+     SIZE = 263,
+     VERS_1 = 264,
+     MANFID = 265,
+     FUNCID = 266,
+     CONFIG = 267,
+     CFTABLE = 268,
+     MFC = 269,
+     CHECKSUM = 270,
+     POST = 271,
+     ROM = 272,
+     BASE = 273,
+     LAST_INDEX = 274,
+     DEV_INFO = 275,
+     ATTR_DEV_INFO = 276,
+     NO_INFO = 277,
+     TIME = 278,
+     TIMING = 279,
+     WAIT = 280,
+     READY = 281,
+     RESERVED = 282,
+     VNOM = 283,
+     VMIN = 284,
+     VMAX = 285,
+     ISTATIC = 286,
+     IAVG = 287,
+     IPEAK = 288,
+     IDOWN = 289,
+     VCC = 290,
+     VPP1 = 291,
+     VPP2 = 292,
+     IO = 293,
+     MEM = 294,
+     DEFAULT = 295,
+     BVD = 296,
+     WP = 297,
+     RDYBSY = 298,
+     MWAIT = 299,
+     AUDIO = 300,
+     READONLY = 301,
+     PWRDOWN = 302,
+     BIT8 = 303,
+     BIT16 = 304,
+     LINES = 305,
+     RANGE = 306,
+     IRQ_NO = 307,
+     MASK = 308,
+     LEVEL = 309,
+     PULSE = 310,
+     SHARED = 311
+   };
+#endif
+
+
+
+#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
+typedef union YYSTYPE
+{
+
+/* Line 214 of yacc.c  */
+#line 61 "mkcis-parser.y"
+
+    char *str;
+    u_long num;
+    float flt;
+    cistpl_power_t pwr;
+    cisparse_t *parse;
+    tuple_info_t *tuple;
+
+
+
+/* Line 214 of yacc.c  */
+#line 226 "mkcis-parser.tab.c"
+} YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
+# define yystype YYSTYPE /* obsolescent; will be withdrawn */
+# define YYSTYPE_IS_DECLARED 1
+#endif
+
+
+/* Copy the second part of user declarations.  */
+
+
+/* Line 264 of yacc.c  */
+#line 238 "mkcis-parser.tab.c"
+
+#ifdef short
+# undef short
+#endif
+
+#ifdef YYTYPE_UINT8
+typedef YYTYPE_UINT8 yytype_uint8;
+#else
+typedef unsigned char yytype_uint8;
+#endif
+
+#ifdef YYTYPE_INT8
+typedef YYTYPE_INT8 yytype_int8;
+#elif (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+typedef signed char yytype_int8;
+#else
+typedef short int yytype_int8;
+#endif
+
+#ifdef YYTYPE_UINT16
+typedef YYTYPE_UINT16 yytype_uint16;
+#else
+typedef unsigned short int yytype_uint16;
+#endif
+
+#ifdef YYTYPE_INT16
+typedef YYTYPE_INT16 yytype_int16;
+#else
+typedef short int yytype_int16;
+#endif
+
+#ifndef YYSIZE_T
+# ifdef __SIZE_TYPE__
+#  define YYSIZE_T __SIZE_TYPE__
+# elif defined size_t
+#  define YYSIZE_T size_t
+# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
+#  define YYSIZE_T size_t
+# else
+#  define YYSIZE_T unsigned int
+# endif
+#endif
+
+#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)
+
+#ifndef YY_
+# if YYENABLE_NLS
+#  if ENABLE_NLS
+#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
+#   define YY_(msgid) dgettext ("bison-runtime", msgid)
+#  endif
+# endif
+# ifndef YY_
+#  define YY_(msgid) msgid
+# endif
+#endif
+
+/* Suppress unused-variable warnings by "using" E.  */
+#if ! defined lint || defined __GNUC__
+# define YYUSE(e) ((void) (e))
+#else
+# define YYUSE(e) /* empty */
+#endif
+
+/* Identity function, used to suppress warnings about constant conditions.  */
+#ifndef lint
+# define YYID(n) (n)
+#else
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static int
+YYID (int yyi)
+#else
+static int
+YYID (yyi)
+    int yyi;
+#endif
+{
+  return yyi;
+}
+#endif
+
+#if ! defined yyoverflow || YYERROR_VERBOSE
+
+/* The parser invokes alloca or malloc; define the necessary symbols.  */
+
+# ifdef YYSTACK_USE_ALLOCA
+#  if YYSTACK_USE_ALLOCA
+#   ifdef __GNUC__
+#    define YYSTACK_ALLOC __builtin_alloca
+#   elif defined __BUILTIN_VA_ARG_INCR
+#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
+#   elif defined _AIX
+#    define YYSTACK_ALLOC __alloca
+#   elif defined _MSC_VER
+#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
+#    define alloca _alloca
+#   else
+#    define YYSTACK_ALLOC alloca
+#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
+#     ifndef _STDLIB_H
+#      define _STDLIB_H 1
+#     endif
+#    endif
+#   endif
+#  endif
+# endif
+
+# ifdef YYSTACK_ALLOC
+   /* Pacify GCC's `empty if-body' warning.  */
+#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
+#  ifndef YYSTACK_ALLOC_MAXIMUM
+    /* The OS might guarantee only one guard page at the bottom of the stack,
+       and a page size can be as small as 4096 bytes.  So we cannot safely
+       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
+       to allow for a few compiler-allocated temporary stack slots.  */
+#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
+#  endif
+# else
+#  define YYSTACK_ALLOC YYMALLOC
+#  define YYSTACK_FREE YYFREE
+#  ifndef YYSTACK_ALLOC_MAXIMUM
+#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
+#  endif
+#  if (defined __cplusplus && ! defined _STDLIB_H \
+       && ! ((defined YYMALLOC || defined malloc) \
+	     && (defined YYFREE || defined free)))
+#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
+#   ifndef _STDLIB_H
+#    define _STDLIB_H 1
+#   endif
+#  endif
+#  ifndef YYMALLOC
+#   define YYMALLOC malloc
+#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
+#   endif
+#  endif
+#  ifndef YYFREE
+#   define YYFREE free
+#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+void free (void *); /* INFRINGES ON USER NAME SPACE */
+#   endif
+#  endif
+# endif
+#endif /* ! defined yyoverflow || YYERROR_VERBOSE */
+
+
+#if (! defined yyoverflow \
+     && (! defined __cplusplus \
+	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
+
+/* A type that is properly aligned for any stack member.  */
+union yyalloc
+{
+  yytype_int16 yyss_alloc;
+  YYSTYPE yyvs_alloc;
+};
+
+/* The size of the maximum gap between one aligned stack and the next.  */
+# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)
+
+/* The size of an array large to enough to hold all stacks, each with
+   N elements.  */
+# define YYSTACK_BYTES(N) \
+     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
+      + YYSTACK_GAP_MAXIMUM)
+
+/* Copy COUNT objects from FROM to TO.  The source and destination do
+   not overlap.  */
+# ifndef YYCOPY
+#  if defined __GNUC__ && 1 < __GNUC__
+#   define YYCOPY(To, From, Count) \
+      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
+#  else
+#   define YYCOPY(To, From, Count)		\
+      do					\
+	{					\
+	  YYSIZE_T yyi;				\
+	  for (yyi = 0; yyi < (Count); yyi++)	\
+	    (To)[yyi] = (From)[yyi];		\
+	}					\
+      while (YYID (0))
+#  endif
+# endif
+
+/* Relocate STACK from its old location to the new one.  The
+   local variables YYSIZE and YYSTACKSIZE give the old and new number of
+   elements in the stack, and YYPTR gives the new location of the
+   stack.  Advance YYPTR to a properly aligned location for the next
+   stack.  */
+# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
+    do									\
+      {									\
+	YYSIZE_T yynewbytes;						\
+	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
+	Stack = &yyptr->Stack_alloc;					\
+	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
+	yyptr += yynewbytes / sizeof (*yyptr);				\
+      }									\
+    while (YYID (0))
+
+#endif
+
+/* YYFINAL -- State number of the termination state.  */
+#define YYFINAL  3
+/* YYLAST -- Last index in YYTABLE.  */
+#define YYLAST   137
+
+/* YYNTOKENS -- Number of terminals.  */
+#define YYNTOKENS  64
+/* YYNNTS -- Number of nonterminals.  */
+#define YYNNTS  19
+/* YYNRULES -- Number of rules.  */
+#define YYNRULES  74
+/* YYNRULES -- Number of states.  */
+#define YYNSTATES  138
+
+/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
+#define YYUNDEFTOK  2
+#define YYMAXUTOK   311
+
+#define YYTRANSLATE(YYX)						\
+  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
+
+/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
+static const yytype_uint8 yytranslate[] =
+{
+       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,    59,    60,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,    61,     2,     2,    63,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,    62,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,    57,     2,    58,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
+       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
+      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
+      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
+      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
+      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
+      55,    56
+};
+
+#if YYDEBUG
+/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
+   YYRHS.  */
+static const yytype_uint8 yyprhs[] =
+{
+       0,     0,     3,     5,     8,     9,    12,    17,    23,    25,
+      27,    29,    31,    33,    35,    37,    39,    41,    43,    49,
+      52,    54,    60,    63,    66,    70,    75,    78,    81,    84,
+      92,    95,    98,   101,   104,   107,   110,   113,   114,   117,
+     120,   124,   128,   132,   138,   144,   147,   150,   156,   159,
+     167,   175,   178,   181,   185,   190,   193,   196,   199,   202,
+     205,   208,   211,   214,   217,   220,   223,   226,   230,   234,
+     238,   240,   242,   244,   246
+};
+
+/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
+static const yytype_int8 yyrhs[] =
+{
+      65,     0,    -1,    66,    -1,    66,    67,    -1,    -1,    66,
+      68,    -1,    14,    57,    66,    58,    -1,    67,    59,    57,
+      66,    58,    -1,    69,    -1,    70,    -1,    71,    -1,    72,
+      -1,    73,    -1,    74,    -1,    81,    -1,    82,    -1,     1,
+      -1,    20,    -1,    69,     4,    23,    59,     8,    -1,    69,
+      22,    -1,    21,    -1,    70,     4,    23,    59,     8,    -1,
+      70,    22,    -1,     9,     5,    -1,    71,    59,     3,    -1,
+      10,     4,    59,     4,    -1,    11,     4,    -1,    73,    16,
+      -1,    73,    17,    -1,    12,    18,     4,    53,     4,    19,
+       4,    -1,    28,     6,    -1,    29,     6,    -1,    30,     6,
+      -1,    31,     7,    -1,    32,     7,    -1,    33,     7,    -1,
+      34,     7,    -1,    -1,    76,    75,    -1,    81,    24,    -1,
+      77,    25,    23,    -1,    77,    26,    23,    -1,    77,    27,
+      23,    -1,    81,    38,     4,    60,     4,    -1,    78,    59,
+       4,    60,     4,    -1,    78,    48,    -1,    78,    49,    -1,
+      78,    50,    61,     4,    62,    -1,    78,    51,    -1,    81,
+      39,     4,    60,     4,    63,     4,    -1,    79,    59,     4,
+      60,     4,    63,     4,    -1,    79,    48,    -1,    79,    49,
+      -1,    81,    52,     4,    -1,    81,    52,    53,     4,    -1,
+      80,    55,    -1,    80,    54,    -1,    80,    56,    -1,    13,
+       4,    -1,    81,    40,    -1,    81,    41,    -1,    81,    42,
+      -1,    81,    43,    -1,    81,    44,    -1,    81,    45,    -1,
+      81,    46,    -1,    81,    47,    -1,    81,    35,    76,    -1,
+      81,    36,    76,    -1,    81,    37,    76,    -1,    78,    -1,
+      79,    -1,    80,    -1,    77,    -1,    15,     4,    60,     4,
+      61,     4,    -1
+};
+
+/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
+static const yytype_uint16 yyrline[] =
+{
+       0,    79,    79,    81,    86,    87,   102,   104,   108,   110,
+     112,   114,   116,   118,   120,   122,   124,   128,   130,   137,
+     140,   142,   149,   152,   162,   176,   184,   189,   191,   195,
+     204,   209,   214,   219,   224,   229,   234,   242,   245,   252,
+     253,   254,   255,   258,   265,   272,   274,   276,   278,   281,
+     289,   297,   299,   303,   305,   310,   312,   314,   318,   323,
+     325,   327,   329,   331,   333,   335,   337,   339,   341,   343,
+     345,   346,   347,   348,   351
+};
+#endif
+
+#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
+/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
+   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
+static const char *const yytname[] =
+{
+  "$end", "error", "$undefined", "STRING", "NUMBER", "FLOAT", "VOLTAGE",
+  "CURRENT", "SIZE", "VERS_1", "MANFID", "FUNCID", "CONFIG", "CFTABLE",
+  "MFC", "CHECKSUM", "POST", "ROM", "BASE", "LAST_INDEX", "DEV_INFO",
+  "ATTR_DEV_INFO", "NO_INFO", "TIME", "TIMING", "WAIT", "READY",
+  "RESERVED", "VNOM", "VMIN", "VMAX", "ISTATIC", "IAVG", "IPEAK", "IDOWN",
+  "VCC", "VPP1", "VPP2", "IO", "MEM", "DEFAULT", "BVD", "WP", "RDYBSY",
+  "MWAIT", "AUDIO", "READONLY", "PWRDOWN", "BIT8", "BIT16", "LINES",
+  "RANGE", "IRQ_NO", "MASK", "LEVEL", "PULSE", "SHARED", "'{'", "'}'",
+  "','", "'-'", "'='", "']'", "'@'", "$accept", "cis", "chain", "mfc",
+  "tuple", "dev_info", "attr_dev_info", "vers_1", "manfid", "funcid",
+  "config", "pwr", "pwrlist", "timing", "io", "mem", "irq", "cftab",
+  "checksum", 0
+};
+#endif
+
+# ifdef YYPRINT
+/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
+   token YYLEX-NUM.  */
+static const yytype_uint16 yytoknum[] =
+{
+       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
+     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
+     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
+     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
+     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
+     305,   306,   307,   308,   309,   310,   311,   123,   125,    44,
+      45,    61,    93,    64
+};
+# endif
+
+/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
+static const yytype_uint8 yyr1[] =
+{
+       0,    64,    65,    65,    66,    66,    67,    67,    68,    68,
+      68,    68,    68,    68,    68,    68,    68,    69,    69,    69,
+      70,    70,    70,    71,    71,    72,    73,    73,    73,    74,
+      75,    75,    75,    75,    75,    75,    75,    76,    76,    77,
+      77,    77,    77,    78,    78,    78,    78,    78,    78,    79,
+      79,    79,    79,    80,    80,    80,    80,    80,    81,    81,
+      81,    81,    81,    81,    81,    81,    81,    81,    81,    81,
+      81,    81,    81,    81,    82
+};
+
+/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
+static const yytype_uint8 yyr2[] =
+{
+       0,     2,     1,     2,     0,     2,     4,     5,     1,     1,
+       1,     1,     1,     1,     1,     1,     1,     1,     5,     2,
+       1,     5,     2,     2,     3,     4,     2,     2,     2,     7,
+       2,     2,     2,     2,     2,     2,     2,     0,     2,     2,
+       3,     3,     3,     5,     5,     2,     2,     5,     2,     7,
+       7,     2,     2,     3,     4,     2,     2,     2,     2,     2,
+       2,     2,     2,     2,     2,     2,     2,     3,     3,     3,
+       1,     1,     1,     1,     6
+};
+
+/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
+   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+   means the default is an error.  */
+static const yytype_uint8 yydefact[] =
+{
+       4,     0,     0,     1,    16,     0,     0,     0,     0,     0,
+       0,     0,    17,    20,     3,     5,     8,     9,    10,    11,
+      12,    13,    73,    70,    71,    72,    14,    15,    23,     0,
+      26,     0,    58,     4,     0,     0,     0,    19,     0,    22,
+       0,    27,    28,     0,     0,     0,    45,    46,     0,    48,
+       0,    51,    52,     0,    56,    55,    57,    39,    37,    37,
+      37,     0,     0,    59,    60,    61,    62,    63,    64,    65,
+      66,     0,     0,     0,     0,     0,     4,     0,     0,    24,
+      40,    41,    42,     0,     0,     0,    67,    68,    69,     0,
+       0,    53,     0,    25,     0,     6,     0,     0,     0,     0,
+       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
+      38,     0,     0,    54,     0,     0,     7,    18,    21,    47,
+      44,     0,    30,    31,    32,    33,    34,    35,    36,    43,
+       0,     0,    74,     0,     0,    29,    50,    49
+};
+
+/* YYDEFGOTO[NTERM-NUM].  */
+static const yytype_int8 yydefgoto[] =
+{
+      -1,     1,     2,    14,    15,    16,    17,    18,    19,    20,
+      21,   110,    86,    22,    23,    24,    25,    26,    27
+};
+
+/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
+   STATE-NUM.  */
+#define YYPACT_NINF -45
+static const yytype_int16 yypact[] =
+{
+     -45,    16,    28,   -45,   -45,    -2,    22,    40,    43,    49,
+     -23,    83,   -45,   -45,   -13,   -45,    13,    14,   -12,   -45,
+      42,   -45,    29,   -44,     3,    30,    36,   -45,   -45,    31,
+     -45,    85,   -45,   -45,    32,    34,    70,   -45,    71,   -45,
+      92,   -45,   -45,    73,    74,    75,   -45,   -45,    38,   -45,
+      96,   -45,   -45,    97,   -45,   -45,   -45,   -45,   -45,   -45,
+     -45,    98,    99,   -45,   -45,   -45,   -45,   -45,   -45,   -45,
+     -45,    -3,   100,    52,    -1,   102,   -45,    48,    50,   -45,
+     -45,   -45,   -45,   104,    51,    53,    35,    35,    35,    54,
+      55,   -45,   106,   -45,   108,   -45,    56,    12,   110,   111,
+      58,   112,   117,   116,   118,   119,   120,   121,   122,   123,
+     -45,   127,   128,   -45,   107,   129,   -45,   -45,   -45,   -45,
+     -45,    60,   -45,   -45,   -45,   -45,   -45,   -45,   -45,   -45,
+      72,   130,   -45,   132,   133,   -45,   -45,   -45
+};
+
+/* YYPGOTO[NTERM-NUM].  */
+static const yytype_int8 yypgoto[] =
+{
+     -45,   -45,   -31,   -45,   -45,   -45,   -45,   -45,   -45,   -45,
+     -45,   -45,   -29,   -45,   -45,   -45,   -45,   -45,   -45
+};
+
+/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
+   positive, shift that token.  If negative, reduce the rule which
+   number is the opposite.  If zero, do what YYDEFACT says.
+   If YYTABLE_NINF, syntax error.  */
+#define YYTABLE_NINF -3
+static const yytype_int16 yytable[] =
+{
+       4,    91,    74,    28,    46,    47,    48,    49,     5,     6,
+       7,     8,     9,     4,    11,    50,     3,    36,    38,    12,
+      13,     5,     6,     7,     8,     9,    29,    11,    -2,     4,
+      87,    88,    12,    13,    33,    37,    39,     5,     6,     7,
+       8,     9,    10,    11,    30,    97,    35,    40,    12,    13,
+      92,    51,    52,    32,    43,    44,    45,    95,    41,    42,
+      57,    31,    53,   103,   104,   105,   106,   107,   108,   109,
+     116,    58,    59,    60,    61,    62,    63,    64,    65,    66,
+      67,    68,    69,    70,    54,    55,    56,    34,    71,    73,
+      72,    76,    75,    77,    78,    79,    80,    81,    82,    83,
+      84,    85,    89,    90,    93,    94,    96,    98,   100,    99,
+     113,   101,   114,   102,   111,   112,   120,   115,   117,   118,
+     119,   121,   122,   133,   123,   124,   131,   125,   126,   127,
+     128,   129,   130,   132,   135,   134,   136,   137
+};
+
+static const yytype_uint8 yycheck[] =
+{
+       1,     4,    33,     5,    48,    49,    50,    51,     9,    10,
+      11,    12,    13,     1,    15,    59,     0,     4,     4,    20,
+      21,     9,    10,    11,    12,    13,     4,    15,     0,     1,
+      59,    60,    20,    21,    57,    22,    22,     9,    10,    11,
+      12,    13,    14,    15,     4,    76,    59,    59,    20,    21,
+      53,    48,    49,     4,    25,    26,    27,    58,    16,    17,
+      24,    18,    59,    28,    29,    30,    31,    32,    33,    34,
+      58,    35,    36,    37,    38,    39,    40,    41,    42,    43,
+      44,    45,    46,    47,    54,    55,    56,     4,    52,     4,
+      59,    57,    60,    23,    23,     3,    23,    23,    23,    61,
+       4,     4,     4,     4,     4,    53,     4,    59,     4,    59,
+       4,    60,     4,    60,    60,    60,     4,    61,     8,     8,
+      62,     4,     6,    63,     6,     6,    19,     7,     7,     7,
+       7,     4,     4,     4,     4,    63,     4,     4
+};
+
+/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
+   symbol of state STATE-NUM.  */
+static const yytype_uint8 yystos[] =
+{
+       0,    65,    66,     0,     1,     9,    10,    11,    12,    13,
+      14,    15,    20,    21,    67,    68,    69,    70,    71,    72,
+      73,    74,    77,    78,    79,    80,    81,    82,     5,     4,
+       4,    18,     4,    57,     4,    59,     4,    22,     4,    22,
+      59,    16,    17,    25,    26,    27,    48,    49,    50,    51,
+      59,    48,    49,    59,    54,    55,    56,    24,    35,    36,
+      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
+      47,    52,    59,     4,    66,    60,    57,    23,    23,     3,
+      23,    23,    23,    61,     4,     4,    76,    76,    76,     4,
+       4,     4,    53,     4,    53,    58,     4,    66,    59,    59,
+       4,    60,    60,    28,    29,    30,    31,    32,    33,    34,
+      75,    60,    60,     4,     4,    61,    58,     8,     8,    62,
+       4,     4,     6,     6,     6,     7,     7,     7,     7,     4,
+       4,    19,     4,    63,    63,     4,     4,     4
+};
+
+#define yyerrok		(yyerrstatus = 0)
+#define yyclearin	(yychar = YYEMPTY)
+#define YYEMPTY		(-2)
+#define YYEOF		0
+
+#define YYACCEPT	goto yyacceptlab
+#define YYABORT		goto yyabortlab
+#define YYERROR		goto yyerrorlab
+
+
+/* Like YYERROR except do call yyerror.  This remains here temporarily
+   to ease the transition to the new meaning of YYERROR, for GCC.
+   Once GCC version 2 has supplanted version 1, this can go.  */
+
+#define YYFAIL		goto yyerrlab
+
+#define YYRECOVERING()  (!!yyerrstatus)
+
+#define YYBACKUP(Token, Value)					\
+do								\
+  if (yychar == YYEMPTY && yylen == 1)				\
+    {								\
+      yychar = (Token);						\
+      yylval = (Value);						\
+      yytoken = YYTRANSLATE (yychar);				\
+      YYPOPSTACK (1);						\
+      goto yybackup;						\
+    }								\
+  else								\
+    {								\
+      yyerror (YY_("syntax error: cannot back up")); \
+      YYERROR;							\
+    }								\
+while (YYID (0))
+
+
+#define YYTERROR	1
+#define YYERRCODE	256
+
+
+/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
+   If N is 0, then set CURRENT to the empty location which ends
+   the previous symbol: RHS[0] (always defined).  */
+
+#define YYRHSLOC(Rhs, K) ((Rhs)[K])
+#ifndef YYLLOC_DEFAULT
+# define YYLLOC_DEFAULT(Current, Rhs, N)				\
+    do									\
+      if (YYID (N))                                                    \
+	{								\
+	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
+	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
+	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
+	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
+	}								\
+      else								\
+	{								\
+	  (Current).first_line   = (Current).last_line   =		\
+	    YYRHSLOC (Rhs, 0).last_line;				\
+	  (Current).first_column = (Current).last_column =		\
+	    YYRHSLOC (Rhs, 0).last_column;				\
+	}								\
+    while (YYID (0))
+#endif
+
+
+/* YY_LOCATION_PRINT -- Print the location on the stream.
+   This macro was not mandated originally: define only if we know
+   we won't break user code: when these are the locations we know.  */
+
+#ifndef YY_LOCATION_PRINT
+# if YYLTYPE_IS_TRIVIAL
+#  define YY_LOCATION_PRINT(File, Loc)			\
+     fprintf (File, "%d.%d-%d.%d",			\
+	      (Loc).first_line, (Loc).first_column,	\
+	      (Loc).last_line,  (Loc).last_column)
+# else
+#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
+# endif
+#endif
+
+
+/* YYLEX -- calling `yylex' with the right arguments.  */
+
+#ifdef YYLEX_PARAM
+# define YYLEX yylex (YYLEX_PARAM)
+#else
+# define YYLEX yylex ()
+#endif
+
+/* Enable debugging if requested.  */
+#if YYDEBUG
+
+# ifndef YYFPRINTF
+#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
+#  define YYFPRINTF fprintf
+# endif
+
+# define YYDPRINTF(Args)			\
+do {						\
+  if (yydebug)					\
+    YYFPRINTF Args;				\
+} while (YYID (0))
+
+# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
+do {									  \
+  if (yydebug)								  \
+    {									  \
+      YYFPRINTF (stderr, "%s ", Title);					  \
+      yy_symbol_print (stderr,						  \
+		  Type, Value); \
+      YYFPRINTF (stderr, "\n");						  \
+    }									  \
+} while (YYID (0))
+
+
+/*--------------------------------.
+| Print this symbol on YYOUTPUT.  |
+`--------------------------------*/
+
+/*ARGSUSED*/
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
+#else
+static void
+yy_symbol_value_print (yyoutput, yytype, yyvaluep)
+    FILE *yyoutput;
+    int yytype;
+    YYSTYPE const * const yyvaluep;
+#endif
+{
+  if (!yyvaluep)
+    return;
+# ifdef YYPRINT
+  if (yytype < YYNTOKENS)
+    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
+# else
+  YYUSE (yyoutput);
+# endif
+  switch (yytype)
+    {
+      default:
+	break;
+    }
+}
+
+
+/*--------------------------------.
+| Print this symbol on YYOUTPUT.  |
+`--------------------------------*/
+
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
+#else
+static void
+yy_symbol_print (yyoutput, yytype, yyvaluep)
+    FILE *yyoutput;
+    int yytype;
+    YYSTYPE const * const yyvaluep;
+#endif
+{
+  if (yytype < YYNTOKENS)
+    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
+  else
+    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);
+
+  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
+  YYFPRINTF (yyoutput, ")");
+}
+
+/*------------------------------------------------------------------.
+| yy_stack_print -- Print the state stack from its BOTTOM up to its |
+| TOP (included).                                                   |
+`------------------------------------------------------------------*/
+
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
+#else
+static void
+yy_stack_print (yybottom, yytop)
+    yytype_int16 *yybottom;
+    yytype_int16 *yytop;
+#endif
+{
+  YYFPRINTF (stderr, "Stack now");
+  for (; yybottom <= yytop; yybottom++)
+    {
+      int yybot = *yybottom;
+      YYFPRINTF (stderr, " %d", yybot);
+    }
+  YYFPRINTF (stderr, "\n");
+}
+
+# define YY_STACK_PRINT(Bottom, Top)				\
+do {								\
+  if (yydebug)							\
+    yy_stack_print ((Bottom), (Top));				\
+} while (YYID (0))
+
+
+/*------------------------------------------------.
+| Report that the YYRULE is going to be reduced.  |
+`------------------------------------------------*/
+
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
+#else
+static void
+yy_reduce_print (yyvsp, yyrule)
+    YYSTYPE *yyvsp;
+    int yyrule;
+#endif
+{
+  int yynrhs = yyr2[yyrule];
+  int yyi;
+  unsigned long int yylno = yyrline[yyrule];
+  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
+	     yyrule - 1, yylno);
+  /* The symbols being reduced.  */
+  for (yyi = 0; yyi < yynrhs; yyi++)
+    {
+      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
+      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
+		       &(yyvsp[(yyi + 1) - (yynrhs)])
+		       		       );
+      YYFPRINTF (stderr, "\n");
+    }
+}
+
+# define YY_REDUCE_PRINT(Rule)		\
+do {					\
+  if (yydebug)				\
+    yy_reduce_print (yyvsp, Rule); \
+} while (YYID (0))
+
+/* Nonzero means print parse trace.  It is left uninitialized so that
+   multiple parsers can coexist.  */
+int yydebug;
+#else /* !YYDEBUG */
+# define YYDPRINTF(Args)
+# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
+# define YY_STACK_PRINT(Bottom, Top)
+# define YY_REDUCE_PRINT(Rule)
+#endif /* !YYDEBUG */
+
+
+/* YYINITDEPTH -- initial size of the parser's stacks.  */
+#ifndef	YYINITDEPTH
+# define YYINITDEPTH 200
+#endif
+
+/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
+   if the built-in stack extension method is used).
+
+   Do not make this value too large; the results are undefined if
+   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
+   evaluated with infinite-precision integer arithmetic.  */
+
+#ifndef YYMAXDEPTH
+# define YYMAXDEPTH 10000
+#endif
+
+
+
+#if YYERROR_VERBOSE
+
+# ifndef yystrlen
+#  if defined __GLIBC__ && defined _STRING_H
+#   define yystrlen strlen
+#  else
+/* Return the length of YYSTR.  */
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static YYSIZE_T
+yystrlen (const char *yystr)
+#else
+static YYSIZE_T
+yystrlen (yystr)
+    const char *yystr;
+#endif
+{
+  YYSIZE_T yylen;
+  for (yylen = 0; yystr[yylen]; yylen++)
+    continue;
+  return yylen;
+}
+#  endif
+# endif
+
+# ifndef yystpcpy
+#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
+#   define yystpcpy stpcpy
+#  else
+/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
+   YYDEST.  */
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static char *
+yystpcpy (char *yydest, const char *yysrc)
+#else
+static char *
+yystpcpy (yydest, yysrc)
+    char *yydest;
+    const char *yysrc;
+#endif
+{
+  char *yyd = yydest;
+  const char *yys = yysrc;
+
+  while ((*yyd++ = *yys++) != '\0')
+    continue;
+
+  return yyd - 1;
+}
+#  endif
+# endif
+
+# ifndef yytnamerr
+/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
+   quotes and backslashes, so that it's suitable for yyerror.  The
+   heuristic is that double-quoting is unnecessary unless the string
+   contains an apostrophe, a comma, or backslash (other than
+   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
+   null, do not copy; instead, return the length of what the result
+   would have been.  */
+static YYSIZE_T
+yytnamerr (char *yyres, const char *yystr)
+{
+  if (*yystr == '"')
+    {
+      YYSIZE_T yyn = 0;
+      char const *yyp = yystr;
+
+      for (;;)
+	switch (*++yyp)
+	  {
+	  case '\'':
+	  case ',':
+	    goto do_not_strip_quotes;
+
+	  case '\\':
+	    if (*++yyp != '\\')
+	      goto do_not_strip_quotes;
+	    /* Fall through.  */
+	  default:
+	    if (yyres)
+	      yyres[yyn] = *yyp;
+	    yyn++;
+	    break;
+
+	  case '"':
+	    if (yyres)
+	      yyres[yyn] = '\0';
+	    return yyn;
+	  }
+    do_not_strip_quotes: ;
+    }
+
+  if (! yyres)
+    return yystrlen (yystr);
+
+  return yystpcpy (yyres, yystr) - yyres;
+}
+# endif
+
+/* Copy into YYRESULT an error message about the unexpected token
+   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
+   including the terminating null byte.  If YYRESULT is null, do not
+   copy anything; just return the number of bytes that would be
+   copied.  As a special case, return 0 if an ordinary "syntax error"
+   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
+   size calculation.  */
+static YYSIZE_T
+yysyntax_error (char *yyresult, int yystate, int yychar)
+{
+  int yyn = yypact[yystate];
+
+  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
+    return 0;
+  else
+    {
+      int yytype = YYTRANSLATE (yychar);
+      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
+      YYSIZE_T yysize = yysize0;
+      YYSIZE_T yysize1;
+      int yysize_overflow = 0;
+      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+      int yyx;
+
+# if 0
+      /* This is so xgettext sees the translatable formats that are
+	 constructed on the fly.  */
+      YY_("syntax error, unexpected %s");
+      YY_("syntax error, unexpected %s, expecting %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
+      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
+# endif
+      char *yyfmt;
+      char const *yyf;
+      static char const yyunexpected[] = "syntax error, unexpected %s";
+      static char const yyexpecting[] = ", expecting %s";
+      static char const yyor[] = " or %s";
+      char yyformat[sizeof yyunexpected
+		    + sizeof yyexpecting - 1
+		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
+		       * (sizeof yyor - 1))];
+      char const *yyprefix = yyexpecting;
+
+      /* Start YYX at -YYN if negative to avoid negative indexes in
+	 YYCHECK.  */
+      int yyxbegin = yyn < 0 ? -yyn : 0;
+
+      /* Stay within bounds of both yycheck and yytname.  */
+      int yychecklim = YYLAST - yyn + 1;
+      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+      int yycount = 1;
+
+      yyarg[0] = yytname[yytype];
+      yyfmt = yystpcpy (yyformat, yyunexpected);
+
+      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
+	  {
+	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+	      {
+		yycount = 1;
+		yysize = yysize0;
+		yyformat[sizeof yyunexpected - 1] = '\0';
+		break;
+	      }
+	    yyarg[yycount++] = yytname[yyx];
+	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
+	    yysize_overflow |= (yysize1 < yysize);
+	    yysize = yysize1;
+	    yyfmt = yystpcpy (yyfmt, yyprefix);
+	    yyprefix = yyor;
+	  }
+
+      yyf = YY_(yyformat);
+      yysize1 = yysize + yystrlen (yyf);
+      yysize_overflow |= (yysize1 < yysize);
+      yysize = yysize1;
+
+      if (yysize_overflow)
+	return YYSIZE_MAXIMUM;
+
+      if (yyresult)
+	{
+	  /* Avoid sprintf, as that infringes on the user's name space.
+	     Don't have undefined behavior even if the translation
+	     produced a string with the wrong number of "%s"s.  */
+	  char *yyp = yyresult;
+	  int yyi = 0;
+	  while ((*yyp = *yyf) != '\0')
+	    {
+	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
+		{
+		  yyp += yytnamerr (yyp, yyarg[yyi++]);
+		  yyf += 2;
+		}
+	      else
+		{
+		  yyp++;
+		  yyf++;
+		}
+	    }
+	}
+      return yysize;
+    }
+}
+#endif /* YYERROR_VERBOSE */
+
+
+/*-----------------------------------------------.
+| Release the memory associated to this symbol.  |
+`-----------------------------------------------*/
+
+/*ARGSUSED*/
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+static void
+yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
+#else
+static void
+yydestruct (yymsg, yytype, yyvaluep)
+    const char *yymsg;
+    int yytype;
+    YYSTYPE *yyvaluep;
+#endif
+{
+  YYUSE (yyvaluep);
+
+  if (!yymsg)
+    yymsg = "Deleting";
+  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);
+
+  switch (yytype)
+    {
+
+      default:
+	break;
+    }
+}
+
+/* Prevent warnings from -Wmissing-prototypes.  */
+#ifdef YYPARSE_PARAM
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void *YYPARSE_PARAM);
+#else
+int yyparse ();
+#endif
+#else /* ! YYPARSE_PARAM */
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void);
+#else
+int yyparse ();
+#endif
+#endif /* ! YYPARSE_PARAM */
+
+
+/* The lookahead symbol.  */
+int yychar;
+
+/* The semantic value of the lookahead symbol.  */
+YYSTYPE yylval;
+
+/* Number of syntax errors so far.  */
+int yynerrs;
+
+
+
+/*-------------------------.
+| yyparse or yypush_parse.  |
+`-------------------------*/
+
+#ifdef YYPARSE_PARAM
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+int
+yyparse (void *YYPARSE_PARAM)
+#else
+int
+yyparse (YYPARSE_PARAM)
+    void *YYPARSE_PARAM;
+#endif
+#else /* ! YYPARSE_PARAM */
+#if (defined __STDC__ || defined __C99__FUNC__ \
+     || defined __cplusplus || defined _MSC_VER)
+int
+yyparse (void)
+#else
+int
+yyparse ()
+
+#endif
+#endif
+{
+
+
+    int yystate;
+    /* Number of tokens to shift before error messages enabled.  */
+    int yyerrstatus;
+
+    /* The stacks and their tools:
+       `yyss': related to states.
+       `yyvs': related to semantic values.
+
+       Refer to the stacks thru separate pointers, to allow yyoverflow
+       to reallocate them elsewhere.  */
+
+    /* The state stack.  */
+    yytype_int16 yyssa[YYINITDEPTH];
+    yytype_int16 *yyss;
+    yytype_int16 *yyssp;
+
+    /* The semantic value stack.  */
+    YYSTYPE yyvsa[YYINITDEPTH];
+    YYSTYPE *yyvs;
+    YYSTYPE *yyvsp;
+
+    YYSIZE_T yystacksize;
+
+  int yyn;
+  int yyresult;
+  /* Lookahead token as an internal (translated) token number.  */
+  int yytoken;
+  /* The variables used to return semantic value and location from the
+     action routines.  */
+  YYSTYPE yyval;
+
+#if YYERROR_VERBOSE
+  /* Buffer for error messages, and its allocated size.  */
+  char yymsgbuf[128];
+  char *yymsg = yymsgbuf;
+  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
+#endif
+
+#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))
+
+  /* The number of symbols on the RHS of the reduced rule.
+     Keep to zero when no symbol should be popped.  */
+  int yylen = 0;
+
+  yytoken = 0;
+  yyss = yyssa;
+  yyvs = yyvsa;
+  yystacksize = YYINITDEPTH;
+
+  YYDPRINTF ((stderr, "Starting parse\n"));
+
+  yystate = 0;
+  yyerrstatus = 0;
+  yynerrs = 0;
+  yychar = YYEMPTY; /* Cause a token to be read.  */
+
+  /* Initialize stack pointers.
+     Waste one element of value and location stack
+     so that they stay on the same level as the state stack.
+     The wasted elements are never initialized.  */
+  yyssp = yyss;
+  yyvsp = yyvs;
+
+  goto yysetstate;
+
+/*------------------------------------------------------------.
+| yynewstate -- Push a new state, which is found in yystate.  |
+`------------------------------------------------------------*/
+ yynewstate:
+  /* In all cases, when you get here, the value and location stacks
+     have just been pushed.  So pushing a state here evens the stacks.  */
+  yyssp++;
+
+ yysetstate:
+  *yyssp = yystate;
+
+  if (yyss + yystacksize - 1 <= yyssp)
+    {
+      /* Get the current used size of the three stacks, in elements.  */
+      YYSIZE_T yysize = yyssp - yyss + 1;
+
+#ifdef yyoverflow
+      {
+	/* Give user a chance to reallocate the stack.  Use copies of
+	   these so that the &'s don't force the real ones into
+	   memory.  */
+	YYSTYPE *yyvs1 = yyvs;
+	yytype_int16 *yyss1 = yyss;
+
+	/* Each stack pointer address is followed by the size of the
+	   data in use in that stack, in bytes.  This used to be a
+	   conditional around just the two extra args, but that might
+	   be undefined if yyoverflow is a macro.  */
+	yyoverflow (YY_("memory exhausted"),
+		    &yyss1, yysize * sizeof (*yyssp),
+		    &yyvs1, yysize * sizeof (*yyvsp),
+		    &yystacksize);
+
+	yyss = yyss1;
+	yyvs = yyvs1;
+      }
+#else /* no yyoverflow */
+# ifndef YYSTACK_RELOCATE
+      goto yyexhaustedlab;
+# else
+      /* Extend the stack our own way.  */
+      if (YYMAXDEPTH <= yystacksize)
+	goto yyexhaustedlab;
+      yystacksize *= 2;
+      if (YYMAXDEPTH < yystacksize)
+	yystacksize = YYMAXDEPTH;
+
+      {
+	yytype_int16 *yyss1 = yyss;
+	union yyalloc *yyptr =
+	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
+	if (! yyptr)
+	  goto yyexhaustedlab;
+	YYSTACK_RELOCATE (yyss_alloc, yyss);
+	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
+#  undef YYSTACK_RELOCATE
+	if (yyss1 != yyssa)
+	  YYSTACK_FREE (yyss1);
+      }
+# endif
+#endif /* no yyoverflow */
+
+      yyssp = yyss + yysize - 1;
+      yyvsp = yyvs + yysize - 1;
+
+      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
+		  (unsigned long int) yystacksize));
+
+      if (yyss + yystacksize - 1 <= yyssp)
+	YYABORT;
+    }
+
+  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
+
+  if (yystate == YYFINAL)
+    YYACCEPT;
+
+  goto yybackup;
+
+/*-----------.
+| yybackup.  |
+`-----------*/
+yybackup:
+
+  /* Do appropriate processing given the current state.  Read a
+     lookahead token if we need one and don't already have one.  */
+
+  /* First try to decide what to do without reference to lookahead token.  */
+  yyn = yypact[yystate];
+  if (yyn == YYPACT_NINF)
+    goto yydefault;
+
+  /* Not known => get a lookahead token if don't already have one.  */
+
+  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
+  if (yychar == YYEMPTY)
+    {
+      YYDPRINTF ((stderr, "Reading a token: "));
+      yychar = YYLEX;
+    }
+
+  if (yychar <= YYEOF)
+    {
+      yychar = yytoken = YYEOF;
+      YYDPRINTF ((stderr, "Now at end of input.\n"));
+    }
+  else
+    {
+      yytoken = YYTRANSLATE (yychar);
+      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
+    }
+
+  /* If the proper action on seeing token YYTOKEN is to reduce or to
+     detect an error, take that action.  */
+  yyn += yytoken;
+  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
+    goto yydefault;
+  yyn = yytable[yyn];
+  if (yyn <= 0)
+    {
+      if (yyn == 0 || yyn == YYTABLE_NINF)
+	goto yyerrlab;
+      yyn = -yyn;
+      goto yyreduce;
+    }
+
+  /* Count tokens shifted since error; after three, turn off error
+     status.  */
+  if (yyerrstatus)
+    yyerrstatus--;
+
+  /* Shift the lookahead token.  */
+  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
+
+  /* Discard the shifted token.  */
+  yychar = YYEMPTY;
+
+  yystate = yyn;
+  *++yyvsp = yylval;
+
+  goto yynewstate;
+
+
+/*-----------------------------------------------------------.
+| yydefault -- do the default action for the current state.  |
+`-----------------------------------------------------------*/
+yydefault:
+  yyn = yydefact[yystate];
+  if (yyn == 0)
+    goto yyerrlab;
+  goto yyreduce;
+
+
+/*-----------------------------.
+| yyreduce -- Do a reduction.  |
+`-----------------------------*/
+yyreduce:
+  /* yyn is the number of a rule to reduce with.  */
+  yylen = yyr2[yyn];
+
+  /* If YYLEN is nonzero, implement the default value of the action:
+     `$$ = $1'.
+
+     Otherwise, the following line sets YYVAL to garbage.
+     This behavior is undocumented and Bison
+     users should not rely upon it.  Assigning to YYVAL
+     unconditionally makes the parser a bit smaller, and it avoids a
+     GCC warning that YYVAL may be used uninitialized.  */
+  yyval = yyvsp[1-yylen];
+
+
+  YY_REDUCE_PRINT (yyn);
+  switch (yyn)
+    {
+        case 2:
+
+/* Line 1455 of yacc.c  */
+#line 80 "mkcis-parser.y"
+    { cis_root = (yyvsp[(1) - (1)].tuple); ;}
+    break;
+
+  case 3:
+
+/* Line 1455 of yacc.c  */
+#line 82 "mkcis-parser.y"
+    { cis_root = (yyvsp[(1) - (2)].tuple); ;}
+    break;
+
+  case 4:
+
+/* Line 1455 of yacc.c  */
+#line 86 "mkcis-parser.y"
+    { (yyval.tuple) = NULL; ;}
+    break;
+
+  case 5:
+
+/* Line 1455 of yacc.c  */
+#line 88 "mkcis-parser.y"
+    {
+		    if ((yyvsp[(1) - (2)].tuple) == NULL) {
+			(yyval.tuple) = (yyvsp[(2) - (2)].tuple);
+		    } else if ((yyvsp[(2) - (2)].tuple) == NULL) {
+			(yyval.tuple) = (yyvsp[(1) - (2)].tuple);
+		    } else {
+			tuple_info_t *tail = (yyvsp[(1) - (2)].tuple);
+			while (tail->next != NULL) tail = tail->next;
+			tail->next = (yyvsp[(2) - (2)].tuple);
+			(yyval.tuple) = (yyvsp[(1) - (2)].tuple);
+		    }
+		;}
+    break;
+
+  case 6:
+
+/* Line 1455 of yacc.c  */
+#line 103 "mkcis-parser.y"
+    { mfc[nf++] = (yyvsp[(3) - (4)].tuple); ;}
+    break;
+
+  case 7:
+
+/* Line 1455 of yacc.c  */
+#line 105 "mkcis-parser.y"
+    { mfc[nf++] = (yyvsp[(4) - (5)].tuple); ;}
+    break;
+
+  case 8:
+
+/* Line 1455 of yacc.c  */
+#line 109 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_DEVICE, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 9:
+
+/* Line 1455 of yacc.c  */
+#line 111 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_DEVICE_A, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 10:
+
+/* Line 1455 of yacc.c  */
+#line 113 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_VERS_1, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 11:
+
+/* Line 1455 of yacc.c  */
+#line 115 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_MANFID, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 12:
+
+/* Line 1455 of yacc.c  */
+#line 117 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_FUNCID, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 13:
+
+/* Line 1455 of yacc.c  */
+#line 119 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_CONFIG, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 14:
+
+/* Line 1455 of yacc.c  */
+#line 121 "mkcis-parser.y"
+    { (yyval.tuple) = new_tuple(CISTPL_CFTABLE_ENTRY, (yyvsp[(1) - (1)].parse)); ;}
+    break;
+
+  case 15:
+
+/* Line 1455 of yacc.c  */
+#line 123 "mkcis-parser.y"
+    { (yyval.tuple) = NULL; ;}
+    break;
+
+  case 16:
+
+/* Line 1455 of yacc.c  */
+#line 125 "mkcis-parser.y"
+    { (yyval.tuple) = NULL; ;}
+    break;
+
+  case 17:
+
+/* Line 1455 of yacc.c  */
+#line 129 "mkcis-parser.y"
+    { (yyval.parse) = calloc(1, sizeof(cisparse_t)); ;}
+    break;
+
+  case 18:
+
+/* Line 1455 of yacc.c  */
+#line 131 "mkcis-parser.y"
+    {
+		    (yyval.parse)->device.dev[(yyval.parse)->device.ndev].type = (yyvsp[(2) - (5)].num);
+		    (yyval.parse)->device.dev[(yyval.parse)->device.ndev].speed = (yyvsp[(3) - (5)].num);
+		    (yyval.parse)->device.dev[(yyval.parse)->device.ndev].size = (yyvsp[(5) - (5)].num);
+		    (yyval.parse)->device.ndev++;
+		;}
+    break;
+
+  case 20:
+
+/* Line 1455 of yacc.c  */
+#line 141 "mkcis-parser.y"
+    { (yyval.parse) = calloc(1, sizeof(cisparse_t)); ;}
+    break;
+
+  case 21:
+
+/* Line 1455 of yacc.c  */
+#line 143 "mkcis-parser.y"
+    {
+		    (yyval.parse)->device.dev[(yyval.parse)->device.ndev].type = (yyvsp[(2) - (5)].num);
+		    (yyval.parse)->device.dev[(yyval.parse)->device.ndev].speed = (yyvsp[(3) - (5)].num);
+		    (yyval.parse)->device.dev[(yyval.parse)->device.ndev].size = (yyvsp[(5) - (5)].num);
+		    (yyval.parse)->device.ndev++;
+		;}
+    break;
+
+  case 23:
+
+/* Line 1455 of yacc.c  */
+#line 153 "mkcis-parser.y"
+    {
+		    (yyval.parse) = calloc(1, sizeof(cisparse_t));
+		    (yyval.parse)->version_1.major = (yyvsp[(2) - (2)].flt);
+		    (yyvsp[(2) - (2)].flt) -= floor((yyvsp[(2) - (2)].flt)+0.01);
+		    while (fabs((yyvsp[(2) - (2)].flt) - floor((yyvsp[(2) - (2)].flt)+0.5)) > 0.01) {
+			(yyvsp[(2) - (2)].flt) *= 10;
+		    }
+		    (yyval.parse)->version_1.minor = (yyvsp[(2) - (2)].flt)+0.01;
+		;}
+    break;
+
+  case 24:
+
+/* Line 1455 of yacc.c  */
+#line 163 "mkcis-parser.y"
+    {
+		    cistpl_vers_1_t *v = &(yyval.parse)->version_1;
+		    u_int pos = 0;
+		    if (v->ns) {
+			pos = v->ofs[v->ns-1];
+			pos += strlen(v->str+pos)+1;
+		    }
+		    v->ofs[v->ns] = pos;
+		    strcpy(v->str+pos, (yyvsp[(3) - (3)].str));
+		    v->ns++;
+		;}
+    break;
+
+  case 25:
+
+/* Line 1455 of yacc.c  */
+#line 177 "mkcis-parser.y"
+    {
+		    (yyval.parse) = calloc(1, sizeof(cisparse_t));
+		    (yyval.parse)->manfid.manf = (yyvsp[(2) - (4)].num);
+		    (yyval.parse)->manfid.card = (yyvsp[(4) - (4)].num);
+		;}
+    break;
+
+  case 26:
+
+/* Line 1455 of yacc.c  */
+#line 185 "mkcis-parser.y"
+    {
+		    (yyval.parse) = calloc(1, sizeof(cisparse_t));
+		    (yyval.parse)->funcid.func = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 27:
+
+/* Line 1455 of yacc.c  */
+#line 190 "mkcis-parser.y"
+    { (yyval.parse)->funcid.sysinit |= CISTPL_SYSINIT_POST; ;}
+    break;
+
+  case 28:
+
+/* Line 1455 of yacc.c  */
+#line 192 "mkcis-parser.y"
+    { (yyval.parse)->funcid.sysinit |= CISTPL_SYSINIT_ROM; ;}
+    break;
+
+  case 29:
+
+/* Line 1455 of yacc.c  */
+#line 196 "mkcis-parser.y"
+    {
+		    (yyval.parse) = calloc(1, sizeof(cisparse_t));
+		    (yyval.parse)->config.base = (yyvsp[(3) - (7)].num);
+		    (yyval.parse)->config.rmask[0] = (yyvsp[(5) - (7)].num);
+		    (yyval.parse)->config.last_idx = (yyvsp[(7) - (7)].num);
+		;}
+    break;
+
+  case 30:
+
+/* Line 1455 of yacc.c  */
+#line 205 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_VNOM;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 31:
+
+/* Line 1455 of yacc.c  */
+#line 210 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_VMIN;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 32:
+
+/* Line 1455 of yacc.c  */
+#line 215 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_VMAX;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 33:
+
+/* Line 1455 of yacc.c  */
+#line 220 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_ISTATIC;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 34:
+
+/* Line 1455 of yacc.c  */
+#line 225 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_IAVG;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 35:
+
+/* Line 1455 of yacc.c  */
+#line 230 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_IPEAK;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 36:
+
+/* Line 1455 of yacc.c  */
+#line 235 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = CISTPL_POWER_IDOWN;
+		    (yyval.pwr).param[0] = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 37:
+
+/* Line 1455 of yacc.c  */
+#line 242 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present = 0;
+		;}
+    break;
+
+  case 38:
+
+/* Line 1455 of yacc.c  */
+#line 246 "mkcis-parser.y"
+    {
+		    (yyval.pwr).present |= 1<<((yyvsp[(2) - (2)].pwr).present);
+		    (yyval.pwr).param[(yyvsp[(2) - (2)].pwr).present] = (yyvsp[(2) - (2)].pwr).param[0];
+		;}
+    break;
+
+  case 43:
+
+/* Line 1455 of yacc.c  */
+#line 259 "mkcis-parser.y"
+    {
+		    int n = (yyval.parse)->cftable_entry.io.nwin;
+		    (yyval.parse)->cftable_entry.io.win[n].base = (yyvsp[(3) - (5)].num);
+		    (yyval.parse)->cftable_entry.io.win[n].len = (yyvsp[(5) - (5)].num)-(yyvsp[(3) - (5)].num)+1;
+		    (yyval.parse)->cftable_entry.io.nwin++;
+		;}
+    break;
+
+  case 44:
+
+/* Line 1455 of yacc.c  */
+#line 266 "mkcis-parser.y"
+    {
+		    int n = (yyval.parse)->cftable_entry.io.nwin;
+		    (yyval.parse)->cftable_entry.io.win[n].base = (yyvsp[(3) - (5)].num);
+		    (yyval.parse)->cftable_entry.io.win[n].len = (yyvsp[(5) - (5)].num)-(yyvsp[(3) - (5)].num)+1;
+		    (yyval.parse)->cftable_entry.io.nwin++;
+		;}
+    break;
+
+  case 45:
+
+/* Line 1455 of yacc.c  */
+#line 273 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.io.flags |= CISTPL_IO_8BIT; ;}
+    break;
+
+  case 46:
+
+/* Line 1455 of yacc.c  */
+#line 275 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.io.flags |= CISTPL_IO_16BIT; ;}
+    break;
+
+  case 47:
+
+/* Line 1455 of yacc.c  */
+#line 277 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.io.flags |= (yyvsp[(4) - (5)].num); ;}
+    break;
+
+  case 49:
+
+/* Line 1455 of yacc.c  */
+#line 282 "mkcis-parser.y"
+    {
+		    int n = (yyval.parse)->cftable_entry.mem.nwin;
+		    (yyval.parse)->cftable_entry.mem.win[n].card_addr = (yyvsp[(3) - (7)].num);
+		    (yyval.parse)->cftable_entry.mem.win[n].host_addr = (yyvsp[(7) - (7)].num);
+		    (yyval.parse)->cftable_entry.mem.win[n].len = (yyvsp[(5) - (7)].num)-(yyvsp[(3) - (7)].num)+1;
+		    (yyval.parse)->cftable_entry.mem.nwin++;
+		;}
+    break;
+
+  case 50:
+
+/* Line 1455 of yacc.c  */
+#line 290 "mkcis-parser.y"
+    {
+		    int n = (yyval.parse)->cftable_entry.mem.nwin;
+		    (yyval.parse)->cftable_entry.mem.win[n].card_addr = (yyvsp[(3) - (7)].num);
+		    (yyval.parse)->cftable_entry.mem.win[n].host_addr = (yyvsp[(7) - (7)].num);
+		    (yyval.parse)->cftable_entry.mem.win[n].len = (yyvsp[(5) - (7)].num)-(yyvsp[(3) - (7)].num)+1;
+		    (yyval.parse)->cftable_entry.mem.nwin++;
+		;}
+    break;
+
+  case 51:
+
+/* Line 1455 of yacc.c  */
+#line 298 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.io.flags |= CISTPL_IO_8BIT; ;}
+    break;
+
+  case 52:
+
+/* Line 1455 of yacc.c  */
+#line 300 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.io.flags |= CISTPL_IO_16BIT; ;}
+    break;
+
+  case 53:
+
+/* Line 1455 of yacc.c  */
+#line 304 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.irq.IRQInfo1 = ((yyvsp[(3) - (3)].num) & 0x0f); ;}
+    break;
+
+  case 54:
+
+/* Line 1455 of yacc.c  */
+#line 306 "mkcis-parser.y"
+    {
+		    (yyval.parse)->cftable_entry.irq.IRQInfo1 = IRQ_INFO2_VALID;
+		    (yyval.parse)->cftable_entry.irq.IRQInfo2 = (yyvsp[(4) - (4)].num);
+		;}
+    break;
+
+  case 55:
+
+/* Line 1455 of yacc.c  */
+#line 311 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.irq.IRQInfo1 |= IRQ_PULSE_ID; ;}
+    break;
+
+  case 56:
+
+/* Line 1455 of yacc.c  */
+#line 313 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.irq.IRQInfo1 |= IRQ_LEVEL_ID; ;}
+    break;
+
+  case 57:
+
+/* Line 1455 of yacc.c  */
+#line 315 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.irq.IRQInfo1 |= IRQ_SHARE_ID; ;}
+    break;
+
+  case 58:
+
+/* Line 1455 of yacc.c  */
+#line 319 "mkcis-parser.y"
+    {
+		    (yyval.parse) = calloc(1, sizeof(cisparse_t));
+		    (yyval.parse)->cftable_entry.index = (yyvsp[(2) - (2)].num);
+		;}
+    break;
+
+  case 59:
+
+/* Line 1455 of yacc.c  */
+#line 324 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_DEFAULT; ;}
+    break;
+
+  case 60:
+
+/* Line 1455 of yacc.c  */
+#line 326 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_BVDS; ;}
+    break;
+
+  case 61:
+
+/* Line 1455 of yacc.c  */
+#line 328 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_WP; ;}
+    break;
+
+  case 62:
+
+/* Line 1455 of yacc.c  */
+#line 330 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_RDYBSY; ;}
+    break;
+
+  case 63:
+
+/* Line 1455 of yacc.c  */
+#line 332 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_MWAIT; ;}
+    break;
+
+  case 64:
+
+/* Line 1455 of yacc.c  */
+#line 334 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_AUDIO; ;}
+    break;
+
+  case 65:
+
+/* Line 1455 of yacc.c  */
+#line 336 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_READONLY; ;}
+    break;
+
+  case 66:
+
+/* Line 1455 of yacc.c  */
+#line 338 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.flags |= CISTPL_CFTABLE_PWRDOWN; ;}
+    break;
+
+  case 67:
+
+/* Line 1455 of yacc.c  */
+#line 340 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.vcc = (yyvsp[(3) - (3)].pwr); ;}
+    break;
+
+  case 68:
+
+/* Line 1455 of yacc.c  */
+#line 342 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.vpp1 = (yyvsp[(3) - (3)].pwr); ;}
+    break;
+
+  case 69:
+
+/* Line 1455 of yacc.c  */
+#line 344 "mkcis-parser.y"
+    { (yyval.parse)->cftable_entry.vpp2 = (yyvsp[(3) - (3)].pwr); ;}
+    break;
+
+  case 74:
+
+/* Line 1455 of yacc.c  */
+#line 352 "mkcis-parser.y"
+    { (yyval.parse) = NULL; ;}
+    break;
+
+
+
+/* Line 1455 of yacc.c  */
+#line 2096 "mkcis-parser.tab.c"
+      default: break;
+    }
+  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
+
+  YYPOPSTACK (yylen);
+  yylen = 0;
+  YY_STACK_PRINT (yyss, yyssp);
+
+  *++yyvsp = yyval;
+
+  /* Now `shift' the result of the reduction.  Determine what state
+     that goes to, based on the state we popped back to and the rule
+     number reduced by.  */
+
+  yyn = yyr1[yyn];
+
+  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
+  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
+    yystate = yytable[yystate];
+  else
+    yystate = yydefgoto[yyn - YYNTOKENS];
+
+  goto yynewstate;
+
+
+/*------------------------------------.
+| yyerrlab -- here on detecting error |
+`------------------------------------*/
+yyerrlab:
+  /* If not already recovering from an error, report this error.  */
+  if (!yyerrstatus)
+    {
+      ++yynerrs;
+#if ! YYERROR_VERBOSE
+      yyerror (YY_("syntax error"));
+#else
+      {
+	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
+	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
+	  {
+	    YYSIZE_T yyalloc = 2 * yysize;
+	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
+	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
+	    if (yymsg != yymsgbuf)
+	      YYSTACK_FREE (yymsg);
+	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
+	    if (yymsg)
+	      yymsg_alloc = yyalloc;
+	    else
+	      {
+		yymsg = yymsgbuf;
+		yymsg_alloc = sizeof yymsgbuf;
+	      }
+	  }
+
+	if (0 < yysize && yysize <= yymsg_alloc)
+	  {
+	    (void) yysyntax_error (yymsg, yystate, yychar);
+	    yyerror (yymsg);
+	  }
+	else
+	  {
+	    yyerror (YY_("syntax error"));
+	    if (yysize != 0)
+	      goto yyexhaustedlab;
+	  }
+      }
+#endif
+    }
+
+
+
+  if (yyerrstatus == 3)
+    {
+      /* If just tried and failed to reuse lookahead token after an
+	 error, discard it.  */
+
+      if (yychar <= YYEOF)
+	{
+	  /* Return failure if at end of input.  */
+	  if (yychar == YYEOF)
+	    YYABORT;
+	}
+      else
+	{
+	  yydestruct ("Error: discarding",
+		      yytoken, &yylval);
+	  yychar = YYEMPTY;
+	}
+    }
+
+  /* Else will try to reuse lookahead token after shifting the error
+     token.  */
+  goto yyerrlab1;
+
+
+/*---------------------------------------------------.
+| yyerrorlab -- error raised explicitly by YYERROR.  |
+`---------------------------------------------------*/
+yyerrorlab:
+
+  /* Pacify compilers like GCC when the user code never invokes
+     YYERROR and the label yyerrorlab therefore never appears in user
+     code.  */
+  if (/*CONSTCOND*/ 0)
+     goto yyerrorlab;
+
+  /* Do not reclaim the symbols of the rule which action triggered
+     this YYERROR.  */
+  YYPOPSTACK (yylen);
+  yylen = 0;
+  YY_STACK_PRINT (yyss, yyssp);
+  yystate = *yyssp;
+  goto yyerrlab1;
+
+
+/*-------------------------------------------------------------.
+| yyerrlab1 -- common code for both syntax error and YYERROR.  |
+`-------------------------------------------------------------*/
+yyerrlab1:
+  yyerrstatus = 3;	/* Each real token shifted decrements this.  */
+
+  for (;;)
+    {
+      yyn = yypact[yystate];
+      if (yyn != YYPACT_NINF)
+	{
+	  yyn += YYTERROR;
+	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
+	    {
+	      yyn = yytable[yyn];
+	      if (0 < yyn)
+		break;
+	    }
+	}
+
+      /* Pop the current state because it cannot handle the error token.  */
+      if (yyssp == yyss)
+	YYABORT;
+
+
+      yydestruct ("Error: popping",
+		  yystos[yystate], yyvsp);
+      YYPOPSTACK (1);
+      yystate = *yyssp;
+      YY_STACK_PRINT (yyss, yyssp);
+    }
+
+  *++yyvsp = yylval;
+
+
+  /* Shift the error token.  */
+  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);
+
+  yystate = yyn;
+  goto yynewstate;
+
+
+/*-------------------------------------.
+| yyacceptlab -- YYACCEPT comes here.  |
+`-------------------------------------*/
+yyacceptlab:
+  yyresult = 0;
+  goto yyreturn;
+
+/*-----------------------------------.
+| yyabortlab -- YYABORT comes here.  |
+`-----------------------------------*/
+yyabortlab:
+  yyresult = 1;
+  goto yyreturn;
+
+#if !defined(yyoverflow) || YYERROR_VERBOSE
+/*-------------------------------------------------.
+| yyexhaustedlab -- memory exhaustion comes here.  |
+`-------------------------------------------------*/
+yyexhaustedlab:
+  yyerror (YY_("memory exhausted"));
+  yyresult = 2;
+  /* Fall through.  */
+#endif
+
+yyreturn:
+  if (yychar != YYEMPTY)
+     yydestruct ("Cleanup: discarding lookahead",
+		 yytoken, &yylval);
+  /* Do not reclaim the symbols of the rule which action triggered
+     this YYABORT or YYACCEPT.  */
+  YYPOPSTACK (yylen);
+  YY_STACK_PRINT (yyss, yyssp);
+  while (yyssp != yyss)
+    {
+      yydestruct ("Cleanup: popping",
+		  yystos[*yyssp], yyvsp);
+      YYPOPSTACK (1);
+    }
+#ifndef yyoverflow
+  if (yyss != yyssa)
+    YYSTACK_FREE (yyss);
+#endif
+#if YYERROR_VERBOSE
+  if (yymsg != yymsgbuf)
+    YYSTACK_FREE (yymsg);
+#endif
+  /* Make sure YYID is used.  */
+  return YYID (yyresult);
+}
+
+
+
+/* Line 1675 of yacc.c  */
+#line 354 "mkcis-parser.y"
+
+
+static tuple_info_t *new_tuple(u_char type, cisparse_t *parse)
+{
+    tuple_info_t *t = calloc(1, sizeof(tuple_info_t));
+    t->type = type;
+    t->parse = parse;
+    t->next = NULL;
+    return t;
+}
+
+void yyerror(char *msg, ...)
+{
+    va_list ap;
+    char str[256];
+
+    va_start(ap, msg);
+    sprintf(str, "error at line %d: ", current_lineno);
+    vsprintf(str+strlen(str), msg, ap);
+    fprintf(stderr, "%s\n", str);
+    va_end(ap);
+}
+
+#ifdef DEBUG
+void main(int argc, char *argv[])
+{
+    if (argc > 1)
+	parse_cis(argv[1]);
+}
+#endif
+
diff --git a/mkcis/mkcis-parser.tab.h b/mkcis/mkcis-parser.tab.h
new file mode 100644
index 0000000..5c37097
--- /dev/null
+++ b/mkcis/mkcis-parser.tab.h
@@ -0,0 +1,127 @@
+
+/* A Bison parser, made by GNU Bison 2.4.1.  */
+
+/* Skeleton interface for Bison's Yacc-like parsers in C
+   
+      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
+   Free Software Foundation, Inc.
+   
+   This program is free software: you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation, either version 3 of the License, or
+   (at your option) any later version.
+   
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+   
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+/* As a special exception, you may create a larger work that contains
+   part or all of the Bison parser skeleton and distribute that work
+   under terms of your choice, so long as that work isn't itself a
+   parser generator using the skeleton or a modified version thereof
+   as a parser skeleton.  Alternatively, if you modify or redistribute
+   the parser skeleton itself, you may (at your option) remove this
+   special exception, which will cause the skeleton and the resulting
+   Bison output files to be licensed under the GNU General Public
+   License without this special exception.
+   
+   This special exception was added by the Free Software Foundation in
+   version 2.2 of Bison.  */
+
+
+/* Tokens.  */
+#ifndef YYTOKENTYPE
+# define YYTOKENTYPE
+   /* Put the tokens into the symbol table, so that GDB and other debuggers
+      know about them.  */
+   enum yytokentype {
+     STRING = 258,
+     NUMBER = 259,
+     FLOAT = 260,
+     VOLTAGE = 261,
+     CURRENT = 262,
+     SIZE = 263,
+     VERS_1 = 264,
+     MANFID = 265,
+     FUNCID = 266,
+     CONFIG = 267,
+     CFTABLE = 268,
+     MFC = 269,
+     CHECKSUM = 270,
+     POST = 271,
+     ROM = 272,
+     BASE = 273,
+     LAST_INDEX = 274,
+     DEV_INFO = 275,
+     ATTR_DEV_INFO = 276,
+     NO_INFO = 277,
+     TIME = 278,
+     TIMING = 279,
+     WAIT = 280,
+     READY = 281,
+     RESERVED = 282,
+     VNOM = 283,
+     VMIN = 284,
+     VMAX = 285,
+     ISTATIC = 286,
+     IAVG = 287,
+     IPEAK = 288,
+     IDOWN = 289,
+     VCC = 290,
+     VPP1 = 291,
+     VPP2 = 292,
+     IO = 293,
+     MEM = 294,
+     DEFAULT = 295,
+     BVD = 296,
+     WP = 297,
+     RDYBSY = 298,
+     MWAIT = 299,
+     AUDIO = 300,
+     READONLY = 301,
+     PWRDOWN = 302,
+     BIT8 = 303,
+     BIT16 = 304,
+     LINES = 305,
+     RANGE = 306,
+     IRQ_NO = 307,
+     MASK = 308,
+     LEVEL = 309,
+     PULSE = 310,
+     SHARED = 311
+   };
+#endif
+
+
+
+#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
+typedef union YYSTYPE
+{
+
+/* Line 1676 of yacc.c  */
+#line 61 "mkcis-parser.y"
+
+    char *str;
+    u_long num;
+    float flt;
+    cistpl_power_t pwr;
+    cisparse_t *parse;
+    tuple_info_t *tuple;
+
+
+
+/* Line 1676 of yacc.c  */
+#line 119 "mkcis-parser.tab.h"
+} YYSTYPE;
+# define YYSTYPE_IS_TRIVIAL 1
+# define yystype YYSTYPE /* obsolescent; will be withdrawn */
+# define YYSTYPE_IS_DECLARED 1
+#endif
+
+extern YYSTYPE yylval;
+
+
diff --git a/mkcis/mkcis-parser.y b/mkcis/mkcis-parser.y
new file mode 100644
index 0000000..c565e0e
--- /dev/null
+++ b/mkcis/mkcis-parser.y
@@ -0,0 +1,383 @@
+%{
+/*
+ * yacc_cis.y 1.11 2000/06/12 21:34:19
+ *
+ * The contents of this file are subject to the Mozilla Public License
+ * Version 1.1 (the "License"); you may not use this file except in
+ * compliance with the License. You may obtain a copy of the License
+ * at http://www.mozilla.org/MPL/
+ *
+ * Software distributed under the License is distributed on an "AS IS"
+ * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
+ * the License for the specific language governing rights and
+ * limitations under the License.
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * Alternatively, the contents of this file may be used under the
+ * terms of the GNU Public License version 2 (the "GPL"), in which
+ * case the provisions of the GPL are applicable instead of the
+ * above.  If you wish to allow the use of your version of this file
+ * only under the terms of the GPL and not to allow others to use
+ * your version of this file under the MPL, indicate your decision by
+ * deleting the provisions above and replace them with the notice and
+ * other provisions required by the GPL.  If you do not delete the
+ * provisions above, a recipient may use your version of this file
+ * under either the MPL or the GPL.
+ */
+
+#include <sys/types.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdarg.h>
+#include <math.h>
+
+#include <cistpl.h>
+
+#include "mkcis.h"
+
+/* If bison: generate nicer error messages */
+#define YYERROR_VERBOSE 1
+
+void yyerror(char *msg, ...);
+static tuple_info_t *new_tuple(u_char type, cisparse_t *parse);
+
+%}
+
+%token STRING NUMBER FLOAT VOLTAGE CURRENT SIZE
+%token VERS_1 MANFID FUNCID CONFIG CFTABLE MFC CHECKSUM
+%token POST ROM BASE LAST_INDEX
+%token DEV_INFO ATTR_DEV_INFO NO_INFO
+%token TIME TIMING WAIT READY RESERVED
+%token VNOM VMIN VMAX ISTATIC IAVG IPEAK IDOWN
+%token VCC VPP1 VPP2 IO MEM
+%token DEFAULT BVD WP RDYBSY MWAIT AUDIO READONLY PWRDOWN
+%token BIT8 BIT16 LINES RANGE
+%token IRQ_NO MASK LEVEL PULSE SHARED
+
+%union {
+    char *str;
+    u_long num;
+    float flt;
+    cistpl_power_t pwr;
+    cisparse_t *parse;
+    tuple_info_t *tuple;
+}
+
+%type <str> STRING
+%type <num> NUMBER SIZE VOLTAGE CURRENT TIME
+%type <flt> FLOAT
+%type <pwr> pwr pwrlist
+%type <parse> vers_1 manfid funcid config cftab io mem irq timing
+%type <parse> dev_info attr_dev_info checksum
+%type <tuple> tuple chain cis;
+%%
+
+cis:	  chain
+		{ cis_root = $1; }
+	| chain mfc
+		{ cis_root = $1; }
+	;
+
+chain:	  /* nothing */
+		{ $$ = NULL; }
+	| chain tuple
+		{
+		    if ($1 == NULL) {
+			$$ = $2;
+		    } else if ($2 == NULL) {
+			$$ = $1;
+		    } else {
+			tuple_info_t *tail = $1;
+			while (tail->next != NULL) tail = tail->next;
+			tail->next = $2;
+			$$ = $1;
+		    }
+		}
+	;
+
+mfc:	  MFC '{' chain '}'
+		{ mfc[nf++] = $3; }
+	| mfc ',' '{' chain '}'
+		{ mfc[nf++] = $4; }
+	;
+
+tuple:	  dev_info
+		{ $$ = new_tuple(CISTPL_DEVICE, $1); }
+	| attr_dev_info
+		{ $$ = new_tuple(CISTPL_DEVICE_A, $1); }
+	| vers_1
+		{ $$ = new_tuple(CISTPL_VERS_1, $1); }
+	| manfid
+		{ $$ = new_tuple(CISTPL_MANFID, $1); }
+	| funcid
+		{ $$ = new_tuple(CISTPL_FUNCID, $1); }
+	| config
+		{ $$ = new_tuple(CISTPL_CONFIG, $1); }
+	| cftab
+		{ $$ = new_tuple(CISTPL_CFTABLE_ENTRY, $1); }
+	| checksum
+		{ $$ = NULL; }
+	| error
+		{ $$ = NULL; }
+	;
+
+dev_info: DEV_INFO
+		{ $$ = calloc(1, sizeof(cisparse_t)); }
+	| dev_info NUMBER TIME ',' SIZE
+		{
+		    $$->device.dev[$$->device.ndev].type = $2;
+		    $$->device.dev[$$->device.ndev].speed = $3;
+		    $$->device.dev[$$->device.ndev].size = $5;
+		    $$->device.ndev++;
+		}
+	| dev_info NO_INFO
+	;
+
+attr_dev_info: ATTR_DEV_INFO
+		{ $$ = calloc(1, sizeof(cisparse_t)); }
+	| attr_dev_info NUMBER TIME ',' SIZE
+		{
+		    $$->device.dev[$$->device.ndev].type = $2;
+		    $$->device.dev[$$->device.ndev].speed = $3;
+		    $$->device.dev[$$->device.ndev].size = $5;
+		    $$->device.ndev++;
+		}
+	| attr_dev_info NO_INFO
+	;
+
+vers_1:	  VERS_1 FLOAT
+		{
+		    $$ = calloc(1, sizeof(cisparse_t));
+		    $$->version_1.major = $2;
+		    $2 -= floor($2+0.01);
+		    while (fabs($2 - floor($2+0.5)) > 0.01) {
+			$2 *= 10;
+		    }
+		    $$->version_1.minor = $2+0.01;
+		}
+	| vers_1 ',' STRING
+		{
+		    cistpl_vers_1_t *v = &$$->version_1;
+		    u_int pos = 0;
+		    if (v->ns) {
+			pos = v->ofs[v->ns-1];
+			pos += strlen(v->str+pos)+1;
+		    }
+		    v->ofs[v->ns] = pos;
+		    strcpy(v->str+pos, $3);
+		    v->ns++;
+		}
+	;
+
+manfid:	  MANFID NUMBER ',' NUMBER
+		{
+		    $$ = calloc(1, sizeof(cisparse_t));
+		    $$->manfid.manf = $2;
+		    $$->manfid.card = $4;
+		}
+	;
+
+funcid:	  FUNCID NUMBER
+		{
+		    $$ = calloc(1, sizeof(cisparse_t));
+		    $$->funcid.func = $2;
+		}
+	| funcid POST
+		{ $$->funcid.sysinit |= CISTPL_SYSINIT_POST; }
+	| funcid ROM
+		{ $$->funcid.sysinit |= CISTPL_SYSINIT_ROM; }
+	;
+
+config:	  CONFIG BASE NUMBER MASK NUMBER  LAST_INDEX NUMBER
+		{
+		    $$ = calloc(1, sizeof(cisparse_t));
+		    $$->config.base = $3;
+		    $$->config.rmask[0] = $5;
+		    $$->config.last_idx = $7;
+		}
+	;
+
+pwr:	  VNOM VOLTAGE
+		{
+		    $$.present = CISTPL_POWER_VNOM;
+		    $$.param[0] = $2;
+		}
+	| VMIN VOLTAGE
+		{
+		    $$.present = CISTPL_POWER_VMIN;
+		    $$.param[0] = $2;
+		}
+	| VMAX VOLTAGE
+		{
+		    $$.present = CISTPL_POWER_VMAX;
+		    $$.param[0] = $2;
+		}
+	| ISTATIC CURRENT
+		{
+		    $$.present = CISTPL_POWER_ISTATIC;
+		    $$.param[0] = $2;
+		}
+	| IAVG CURRENT
+		{
+		    $$.present = CISTPL_POWER_IAVG;
+		    $$.param[0] = $2;
+		}
+	| IPEAK CURRENT
+		{
+		    $$.present = CISTPL_POWER_IPEAK;
+		    $$.param[0] = $2;
+		}
+	| IDOWN CURRENT
+		{
+		    $$.present = CISTPL_POWER_IDOWN;
+		    $$.param[0] = $2;
+		}
+	;
+
+pwrlist:  /* nothing */
+		{
+		    $$.present = 0;
+		}
+	| pwrlist pwr
+		{
+		    $$.present |= 1<<($2.present);
+		    $$.param[$2.present] = $2.param[0];
+		}
+	;
+
+timing:	  cftab TIMING
+	| timing WAIT TIME
+	| timing READY TIME
+	| timing RESERVED TIME
+	;
+
+io:	  cftab IO NUMBER '-' NUMBER
+		{
+		    int n = $$->cftable_entry.io.nwin;
+		    $$->cftable_entry.io.win[n].base = $3;
+		    $$->cftable_entry.io.win[n].len = $5-$3+1;
+		    $$->cftable_entry.io.nwin++;
+		}
+	| io ',' NUMBER '-' NUMBER
+		{
+		    int n = $$->cftable_entry.io.nwin;
+		    $$->cftable_entry.io.win[n].base = $3;
+		    $$->cftable_entry.io.win[n].len = $5-$3+1;
+		    $$->cftable_entry.io.nwin++;
+		}
+	| io BIT8
+		{ $$->cftable_entry.io.flags |= CISTPL_IO_8BIT; }
+	| io BIT16
+		{ $$->cftable_entry.io.flags |= CISTPL_IO_16BIT; }
+	| io LINES '=' NUMBER ']'
+		{ $$->cftable_entry.io.flags |= $4; }
+	| io RANGE
+	;
+
+mem:	  cftab MEM NUMBER '-' NUMBER '@' NUMBER
+		{
+		    int n = $$->cftable_entry.mem.nwin;
+		    $$->cftable_entry.mem.win[n].card_addr = $3;
+		    $$->cftable_entry.mem.win[n].host_addr = $7;
+		    $$->cftable_entry.mem.win[n].len = $5-$3+1;
+		    $$->cftable_entry.mem.nwin++;
+		}
+	| mem ',' NUMBER '-' NUMBER '@' NUMBER
+		{
+		    int n = $$->cftable_entry.mem.nwin;
+		    $$->cftable_entry.mem.win[n].card_addr = $3;
+		    $$->cftable_entry.mem.win[n].host_addr = $7;
+		    $$->cftable_entry.mem.win[n].len = $5-$3+1;
+		    $$->cftable_entry.mem.nwin++;
+		}
+	| mem BIT8
+		{ $$->cftable_entry.io.flags |= CISTPL_IO_8BIT; }
+	| mem BIT16
+		{ $$->cftable_entry.io.flags |= CISTPL_IO_16BIT; }
+	;
+
+irq:	  cftab IRQ_NO NUMBER
+		{ $$->cftable_entry.irq.IRQInfo1 = ($3 & 0x0f); }
+	| cftab IRQ_NO MASK NUMBER
+		{
+		    $$->cftable_entry.irq.IRQInfo1 = IRQ_INFO2_VALID;
+		    $$->cftable_entry.irq.IRQInfo2 = $4;
+		}
+	| irq PULSE
+		{ $$->cftable_entry.irq.IRQInfo1 |= IRQ_PULSE_ID; }
+	| irq LEVEL
+		{ $$->cftable_entry.irq.IRQInfo1 |= IRQ_LEVEL_ID; }
+	| irq SHARED
+		{ $$->cftable_entry.irq.IRQInfo1 |= IRQ_SHARE_ID; }
+	;
+
+cftab:	  CFTABLE NUMBER
+		{
+		    $$ = calloc(1, sizeof(cisparse_t));
+		    $$->cftable_entry.index = $2;
+		}
+	| cftab DEFAULT
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_DEFAULT; }
+	| cftab BVD
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_BVDS; }
+	| cftab WP
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_WP; }
+	| cftab RDYBSY
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_RDYBSY; }
+	| cftab MWAIT
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_MWAIT; }
+	| cftab AUDIO
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_AUDIO; }
+	| cftab READONLY
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_READONLY; }
+	| cftab PWRDOWN
+		{ $$->cftable_entry.flags |= CISTPL_CFTABLE_PWRDOWN; }
+	| cftab VCC pwrlist
+		{ $$->cftable_entry.vcc = $3; }
+	| cftab VPP1 pwrlist
+		{ $$->cftable_entry.vpp1 = $3; }
+	| cftab VPP2 pwrlist
+		{ $$->cftable_entry.vpp2 = $3; }
+	| io
+	| mem
+	| irq
+	| timing
+	;
+
+checksum: CHECKSUM NUMBER '-' NUMBER '=' NUMBER
+	{ $$ = NULL; }
+
+%%
+
+static tuple_info_t *new_tuple(u_char type, cisparse_t *parse)
+{
+    tuple_info_t *t = calloc(1, sizeof(tuple_info_t));
+    t->type = type;
+    t->parse = parse;
+    t->next = NULL;
+    return t;
+}
+
+void yyerror(char *msg, ...)
+{
+    va_list ap;
+    char str[256];
+
+    va_start(ap, msg);
+    sprintf(str, "error at line %d: ", current_lineno);
+    vsprintf(str+strlen(str), msg, ap);
+    fprintf(stderr, "%s\n", str);
+    va_end(ap);
+}
+
+#ifdef DEBUG
+void main(int argc, char *argv[])
+{
+    if (argc > 1)
+	parse_cis(argv[1]);
+}
+#endif
diff --git a/mkcis/mkcis.c b/mkcis/mkcis.c
new file mode 100644
index 0000000..b1fc5c6
--- /dev/null
+++ b/mkcis/mkcis.c
@@ -0,0 +1,471 @@
+/*======================================================================
+
+	A utility to convert a plain text description of a Card
+	Information Structure into its packed binary representation.
+
+	The contents of this file are subject to the Mozilla Public
+	License Version 1.1 (the "License"); you may not use this file
+	except in compliance with the License. You may obtain a copy of
+	the License at http://www.mozilla.org/MPL/
+
+	Software distributed under the License is distributed on an "AS
+	IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
+	implied. See the License for the specific language governing
+	rights and limitations under the License.
+
+	The initial developer of the original code is David A. Hinds
+	<dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+	are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+
+	Alternatively, the contents of this file may be used under the
+	terms of the GNU Public License version 2 (the "GPL"), in which
+	case the provisions of the GPL are applicable instead of the
+	above.  If you wish to allow the use of your version of this file
+	only under the terms of the GPL and not to allow others to use
+	your version of this file under the MPL, indicate your decision
+	by deleting the provisions above and replace them with the notice
+	and other provisions required by the GPL.  If you do not delete
+	the provisions above, a recipient may use your version of this
+	file under either the MPL or the GPL.
+
+	Usage:
+
+	mkcis [-o outfile] [infile]
+
+	[infile] defaults to stdin, and [outfile] defaults to stdout.
+
+======================================================================*/
+
+#include <sys/types.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <getopt.h>
+#include <errno.h>
+
+#include <cistpl.h>
+
+#include "mkcis.h"
+
+tuple_info_t *cis_root, *mfc[8] = { NULL };
+int nf;
+
+/*======================================================================
+
+	Support routines for packing parts of configuration table entries
+
+======================================================================*/
+
+static u_int mantissa[] = {
+	10, 12, 13, 15, 20, 25, 30, 35,
+	40, 45, 50, 55, 60, 70, 80, 90
+};
+static int pack_power(cistpl_power_t *pwr, u_char *b)
+{
+	u_int tmp, i;
+	u_char m = 0 , e, x = 0, *c = b;
+	*c = pwr->present; c++;
+	for (i = 0; i < 7; i++) {
+		if (!(pwr->present & (1<<i)))
+			continue;
+		tmp = pwr->param[i];
+		for (e = 1; ((tmp % 10) == 0) || (tmp > 999); e++)
+			tmp /= 10;
+		if (tmp < 100) {
+			if (tmp < 10) {
+				tmp *= 10;
+				e--;
+			}
+			for (m = 0; m < 16; m++)
+				if (mantissa[m] == tmp)
+					break;
+			if (m == 16) {
+				tmp *= 10;
+				e--;
+			}
+			x = 0;
+		}
+		if (tmp >= 100) {
+			e++;
+			x = (tmp/10) - ((tmp/10) % 10);
+			for (m = 0; m < 16; m++)
+				if (mantissa[m] == x)
+					break;
+			x = (u_char)(tmp - 10*(u_int)x);
+		}
+		*c = (m<<3) | e | (x ? 0x80 : 0); c++;
+		if (x) {
+			*c = x;
+			c++;
+		}
+	}
+	return c-b;
+}
+
+static int pack_io(cistpl_io_t *p, u_char *b)
+{
+	u_char *c = b;
+	u_int i, j, ml, ma;
+	*c = p->flags & (CISTPL_IO_8BIT|CISTPL_IO_16BIT);
+	if ((p->nwin == 1) && (p->win[0].base == 0)) {
+		for (i = 1, j = 0; i < p->win[0].len; i *= 2, j++)
+			;
+		*c |= j; c++;
+	} else {
+		for (i = ma = ml = 0; i < p->nwin; i++) {
+			ma |= p->win[i].base;
+			ml |= p->win[i].len-1;
+		}
+		ma = (ma > 0xffff) ? 3 : ((ma > 0xff) ? 2 : 1);
+		ml = (ml > 0xffff) ? 3 : ((ml > 0xff) ? 2 : 1);
+		*c |= 0x80 | (p->flags & CISTPL_IO_LINES_MASK); c++;
+		*c = (p->nwin-1) | (ma<<4) | (ml<<6); c++;
+		if (ma == 3)
+			ma++;
+		if (ml == 3)
+			ml++;
+		for (i = 0; i < p->nwin; i++) {
+			for (j = 0; j < ma; j++) {
+				*c = (p->win[i].base >> (8*j)) & 0xff; c++;
+			}
+			for (j = 0; j < ml; j++) {
+				*c = ((p->win[i].len-1) >> (8*j)) & 0xff; c++;
+			}
+		}
+	}
+	return c-b;
+}
+
+static int pack_mem(cistpl_mem_t *p, u_char *b)
+{
+	u_char *c = b;
+	u_int i, j, ml, ma, ha;
+	for (i = ma = ml = ha = 0; i < p->nwin; i++) {
+		ma |= p->win[i].card_addr;
+		ml |= p->win[i].len;
+		ha |= p->win[i].host_addr;
+	}
+	ma = (ma|ha) >> 8; ml >>= 8;
+	ma = (ma > 0xffff) ? 3 : ((ma > 0xff) ? 2 : 1);
+	ml = (ml > 0xffff) ? 3 : ((ml > 0xff) ? 2 : 1);
+	*c = (p->nwin-1) | (ma<<5) | (ml<<3) | (ha ? 0x80 : 0); c++;
+	for (i = 0; i < p->nwin; i++) {
+		for (j = 1; j <= ml; j++) {
+			*c = (p->win[i].len >> (8*j)) & 0xff; c++;
+		}
+		for (j = 1; j <= ma; j++) {
+			*c = (p->win[i].card_addr >> (8*j)) & 0xff; c++;
+		}
+		if (ha)
+			for (j = 1; j <= ma; j++) {
+				*c = (p->win[i].host_addr >> (8*j)) & 0xff; c++;
+			}
+	}
+	return c-b;
+}
+
+static int pack_irq(cistpl_irq_t *p, u_char *b)
+{
+	b[0] = p->IRQInfo1;
+	if (p->IRQInfo1 & IRQ_INFO2_VALID) {
+		b[1] = p->IRQInfo2 & 0xff;
+		b[2] = (p->IRQInfo2 >> 8) & 0xff;
+		return 3;
+	}
+	return 1;
+}
+
+static void pack_cftable(cistpl_cftable_entry_t *p, u_char *b)
+{
+	u_char *c;
+	b[2] = p->index | 0x80;
+	if (p->flags & CISTPL_CFTABLE_DEFAULT)
+		b[2] |= 0x40;
+	b[3] = 0x01;
+	b[3] |= (p->flags & CISTPL_CFTABLE_BVDS) ? 0x10 : 0;
+	b[3] |= (p->flags & CISTPL_CFTABLE_WP) ? 0x20 : 0;
+	b[3] |= (p->flags & CISTPL_CFTABLE_RDYBSY) ? 0x40 : 0;
+	b[3] |= (p->flags & CISTPL_CFTABLE_MWAIT) ? 0x80 : 0;
+	b[4] = 0;
+	c = b+5;
+	if (p->vcc.present) {
+		b[4]++; c += pack_power(&p->vcc, c);
+		if (p->vpp1.present) {
+			b[4]++; c += pack_power(&p->vpp1, c);
+			if (p->vpp2.present) {
+				b[4]++; c += pack_power(&p->vpp2, c);
+			}
+		}
+	}
+	if (p->io.nwin > 0) {
+		b[4] |= 0x08;
+		c += pack_io(&p->io, c);
+	}
+	if (p->irq.IRQInfo1 > 0) {
+		b[4] |= 0x10;
+		c += pack_irq(&p->irq, c);
+	}
+	if (p->mem.nwin > 0) {
+		b[4] |= 0x60;
+		c += pack_mem(&p->mem, c);
+	}
+	if (p->flags >> 8) {
+		b[4] |= 0x80;
+		*c++ = p->flags >> 8;
+	}
+	b[1] = c-b-2;
+}
+
+/*======================================================================
+
+	Routines for packing device info tuples
+
+======================================================================*/
+
+static int pack_speed(u_int speed, u_char *b)
+{
+	u_char e, m, *c = b;
+	switch (speed) {
+	case 0:
+		*c |= 0;
+		c++;
+		break;
+	case 250:
+		*c |= 1;
+		c++;
+		break;
+	case 200:
+		*c |= 2;
+		c++;
+		break;
+	case 150:
+		*c |= 3;
+		c++;
+		break;
+	case 100:
+		*c |= 4;
+		c++;
+		break;
+	default:
+		*c |= 7;
+		c++;
+		for (e = 1; speed > 80; e++)
+			speed /= 10;
+		for (m = 0; m < 15; m++)
+			if (mantissa[m] >= speed)
+				break;
+		*c = ((m+1)<<3) | e;
+		c++;
+	}
+	return c-b;
+}
+
+static void pack_device(cistpl_device_t *d, u_char *b)
+{
+	u_int i, sz;
+	u_char e, *c = b+2;
+	for (i = 0; i < d->ndev; i++) {
+		*c = (d->dev[i].type<<4);
+		c += pack_speed(d->dev[i].speed, c);
+		sz = d->dev[i].size/512;
+		for (e = 0; sz > 32; e++)
+			sz /= 4;
+		*c = (e & 7) | ((sz-1) << 3); c++;
+	}
+	*c = 0xff; c++;
+	b[1] = c-b-2;
+}
+
+/*======================================================================
+
+	For now, I only implement a subset of tuples types, intended to be
+	enough to handle most IO-oriented cards.
+
+======================================================================*/
+
+static int pack_tuple(tuple_info_t *t, u_char *b)
+{
+	cisparse_t *p = t->parse;
+	u_int i, m;
+	u_char *c;
+
+	*b = t->type;
+	switch (t->type) {
+	case CISTPL_DEVICE:
+	case CISTPL_DEVICE_A:
+		if (p) {
+			pack_device(&p->device, b);
+		} else {
+			/* Fake null device tuple */
+			b[1] = 3; b[2] = 0; b[3] = 0; b[4] = 0xff;
+		}
+		break;
+	case CISTPL_MANFID:
+		b[1] = 4;
+		b[2] = p->manfid.manf & 0xff;
+		b[3] = p->manfid.manf >> 8;
+		b[4] = p->manfid.card & 0xff;
+		b[5] = p->manfid.card >> 8;
+		break;
+	case CISTPL_FUNCID:
+		b[1] = 2;
+		b[2] = p->funcid.func;
+		b[3] = p->funcid.sysinit;
+		break;
+	case CISTPL_CONFIG:
+		b[3] = p->config.last_idx;
+		i = p->config.base;
+		for (c = b+4, m = 0; (i > 0) || !m; i >>= 8, m++)
+			c[m] = i & 0xff;
+		b[2] = m-1;
+		i = p->config.rmask[0];
+		for (c = c+m, m = 0; (i > 0) || !m; i >>= 8, m++)
+			c[m] = i & 0xff;
+		b[2] |= ((m-1) << 2);
+		b[1] = c+m-b-2;
+		break;
+	case CISTPL_VERS_1:
+		b[2] = p->version_1.major;
+		b[3] = p->version_1.minor;
+		c = b+4;
+		for (i = 0; i < p->version_1.ns; i++) {
+			strcpy((char *)c, p->version_1.str+p->version_1.ofs[i]);
+			c += strlen((char *)c) + 1;
+		}
+		for (; i < 4; i++) {
+			*c = 0;
+			c++;
+		}
+		*c = 0xff; c++;
+		b[1] = c-b-2;
+		break;
+	case CISTPL_CFTABLE_ENTRY:
+		pack_cftable(&p->cftable_entry, b);
+		break;
+	case CISTPL_LINKTARGET:
+		b[1] = 3; b[2] = 'C'; b[3] = 'I'; b[4] = 'S';
+		break;
+	case CISTPL_NO_LINK:
+	case CISTPL_END:
+		b[1] = 0;
+		break;
+	}
+	return b[1]+2;
+}
+
+/*======================================================================
+
+	The following routines handle parsing of aggregates of tuples.
+	pack_chain() is the simplest: just return a string of tuples and
+	terminate with an END tuple.  pack_mfc() is used to tie the
+	function-specific tuple chains for a multifunction card together
+	using a LONGLINK_MFC tuple.  And pack_cis() handles a complete
+	CIS, whether it is multifunction or not.
+
+======================================================================*/
+
+static int pack_chain(tuple_info_t *t, u_char *b)
+{
+	int n = 0;
+	tuple_info_t end = { CISTPL_END, NULL, NULL };
+	while (t) {
+		n += pack_tuple(t, b+n);
+		t = t->next;
+	}
+	n += pack_tuple(&end, b+n);
+	return n;
+}
+
+static int pack_mfc(u_int ofs, u_char *b)
+{
+	u_int i, j, pos;
+	tuple_info_t target = { CISTPL_LINKTARGET, NULL, NULL };
+
+	b[0] = CISTPL_LONGLINK_MFC;
+	b[1] = 5*nf + 1;
+	b[2] = nf;
+	b[5*nf+3] = CISTPL_END;
+	b[5*nf+4] = 0;
+	/* Leave space for this tuple and the CISTPL_END tuple */
+	pos = 5*nf+5;
+	for (i = 0; i < nf; i++) {
+		b[3+i*5] = 0;
+		for (j = 0; j < 4; j++)
+			b[4+i*5+j] = ((ofs+pos) >> (8*j)) & 0xff;
+		pos += pack_tuple(&target, b+pos);
+		pos += pack_chain(mfc[i], b+pos);
+	}
+	return ofs+pos;
+}
+
+static int pack_cis(tuple_info_t *t, u_char *b)
+{
+	int n = 0;
+	tuple_info_t device = { CISTPL_DEVICE, NULL, NULL };
+	tuple_info_t nolink = { CISTPL_NO_LINK, NULL, NULL };
+	tuple_info_t end = { CISTPL_END, NULL, NULL };
+	if (t->type != CISTPL_DEVICE)
+		n = pack_tuple(&device, b);
+	while (t) {
+		n += pack_tuple(t, b+n);
+		t = t->next;
+	}
+	if (nf > 0) {
+		n = pack_mfc(n, b+n);
+	} else {
+		n += pack_tuple(&nolink, b+n);
+		n += pack_tuple(&end, b+n);
+	}
+	 return n;
+}
+
+/*====================================================================*/
+
+int main(int argc, char *argv[])
+{
+	int optch, errflg = 0;
+	char *out = NULL;
+	u_char buf[1024];
+	int n;
+	FILE *f;
+
+	while ((optch = getopt(argc, argv, "o:")) != -1) {
+		switch (optch) {
+		case 'o':
+			out = strdup(optarg); break;
+		default:
+			errflg = 1; break;
+		}
+	}
+	if (errflg || (optind < argc-1)) {
+		fprintf(stderr, "usage: %s [-o outfile] [infile]\n",
+				argv[0]);
+		exit(EXIT_FAILURE);
+	}
+	if (optind < argc) {
+		f = fopen(argv[optind], "r");
+		if (!f) {
+			fprintf(stderr, "could not open '%s': %s\n",
+					argv[optind],
+					strerror(errno));
+			return -1;
+		}
+	} else
+		f = stdin;
+	parse_cis(f);
+	fclose(f);
+	n = pack_cis(cis_root, buf);
+	if (out) {
+		f = fopen(out, "w");
+		if (!f) {
+			fprintf(stderr, "could not open '%s': %s\n", out,
+					strerror(errno));
+			return -1;
+		}
+	} else
+		f = stdout;
+	fwrite(buf, n, 1, f);
+	fclose(f);
+
+	return 0;
+}
diff --git a/mkcis/mkcis.h b/mkcis/mkcis.h
new file mode 100644
index 0000000..bf06f9b
--- /dev/null
+++ b/mkcis/mkcis.h
@@ -0,0 +1,49 @@
+/*
+ * pack_cis.h 1.6 2000/06/12 21:34:19
+ *
+ * The contents of this file are subject to the Mozilla Public License
+ * Version 1.1 (the "License"); you may not use this file except in
+ * compliance with the License. You may obtain a copy of the License
+ * at http://www.mozilla.org/MPL/
+ *
+ * Software distributed under the License is distributed on an "AS IS"
+ * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
+ * the License for the specific language governing rights and
+ * limitations under the License.
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * Alternatively, the contents of this file may be used under the
+ * terms of the GNU Public License version 2 (the "GPL"), in which
+ * case the provisions of the GPL are applicable instead of the
+ * above.  If you wish to allow the use of your version of this file
+ * only under the terms of the GPL and not to allow others to use
+ * your version of this file under the MPL, indicate your decision by
+ * deleting the provisions above and replace them with the notice and
+ * other provisions required by the GPL.  If you do not delete the
+ * provisions above, a recipient may use your version of this file
+ * under either the MPL or the GPL.
+ */
+typedef struct tuple_info_t {
+	u_char			type;
+	cisparse_t		*parse;
+	struct tuple_info_t	*next;
+} tuple_info_t;
+
+extern tuple_info_t *cis_root, *mfc[8];
+extern int nf;
+
+void parse_cis(FILE *f);
+
+/* removed from pcmcia/cs.h */
+#define IRQ_INFO2_VALID		0x10
+#define IRQ_LEVEL_ID		0x20
+#define IRQ_PULSE_ID		0x40
+#define IRQ_SHARE_ID		0x80
+
+/* lex-yacc interface */
+extern int current_lineno;
+extern int yylex(void);
+extern int yyparse(void);
-- 
1.7.1

