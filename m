Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab2IZFHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:07:15 -0400
Received: from nm18-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.138]:45837 "HELO
	nm18-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750890Ab2IZFHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:07:12 -0400
X-Yahoo-Newman-Id: 527326.78794.bm@omp1021.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LfqyGBIVM1k037137LHv6hSapplsML72wrKuzVJCsxI1Qgd
 nFkTNkKIglarvlVu5eyyBfbAYyv52Q0nE6avvCL.EKuBNZNdxt43vFbvMUZh
 3ILRJT0i59A05hTRR7y2DYdcvMlKFMNR9BAbMwR3pSHCmLHnQ7aScSsprykW
 02AR6HWp2cre.zyZ9E_.zkdgU.pv710nEXgblNfSVBOlOvLqSOQ4KzArllxN
 ymNP2OZeM1E1AWP6IwXhuGyVhFWwaQtBcQpYItWx6Xqu98_yDOIhjeQoq3yA
 BR2FgalhPGvAZQ0f3ZPjESJj1qmW4J_wskq4_5mGWaJODwLuh.86917UxmpK
 1rl2tZTauSE.R8CJ0RqONeLjI.bi.tgJ0z4OPtuNFFrAaifKUn.emPUUhg2y
 255xlc41gAQFv0TD64JyE4A0MLDPadupkx_TfpNUrzVKRTspFb.73xdCJG8_
 S27vT8REKrF2y3ruuevTeclWiGSI4JGy4Fy62Xs_pyFoTzKGhVBQOUg0LKI_
 WLwsmoiEzlmwY4le9ZmNrDfD3.HORT1iihrsro2IwnA1dAGlRbwWFr8Pcer4
 SVFoih_97YAI_eanyylzg61vmyRr6Td_U5C.OzEWUHv01THLkkUiba.Axx3N
 oTWw-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50628D7E.1030908@att.net>
Date: Wed, 26 Sep 2012 00:07:10 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/25] Generic Red-Black Trees (still WIP)
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, looks like I've had some type of mailer problem as this message
didn't appear on LKML :(  I hope this one goes through, but sorry my
patches aren't properly grouped.

On 09/25/2012 06:24 PM, Daniel Santos wrote:
> First I want to apologize for not being able to work on this over most of the
> summer. I see that some other changes are happening with red-black and
> interval trees in the kernel which look good.  This patch set is based on v3.5
> and is not adjusted for many of the changes in Michel Lespinasse's patches.
> This is still WIP as I have added a good deal of new test code and made a fair
> number of performance tweaks, but I needed to get something out for review
> again to keep this thing rolling.
>
> Summary
> =======
> This patch set improves on Andrea Arcangeli's original Red-Black Tree
> implementation by adding generic search and insert functions with
> complete support for:
>
> o leftmost - keeps a pointer to the leftmost (lowest value) node cached
>   in your container struct
> o rightmost - ditto for rightmost (greatest value)
> o count - optionally update an count variable when you perform inserts
>   or deletes
> o unique or non-unique keys
> o find and insert "near" functions - when you already have a node that
>   is likely near another one you want to search for
> o augmented / interval tree support
> o type-safe wrapper interface available via pre-processor macro
>
> Outstanding Issues
> ==================
> General
> -------
> o Need to change comments at head of rbtree.h.
> o Need something in Documents to explain generic rbtrees.
> o Descriptions for new KConfig values incomplete.
> o Due to a bug in gcc's optimizer, extra instructions are generated in various
>   places.  Pavel Pisa has provided me a possible work-around that should be
>   examined more closely to see if it can be working in (Discussed in
>   Performance section).
> o Doc-comments are missing or out of date in some places for the new
>   ins_compare field of struct rb_relationship (including at least one code
>   example).
>
> Selftests
> ---------
> o In-kernel test module not completed, although the option to build it has
>   already been added to KConfig.
> o Userspace selftest's Makefile should run modules_prepare in KERNELDIR.
> o Validation in self-tests doesn't yet cover tests for
>   - insert_near
>   - find_{first,last,next,prev}
> o Selftest scripts need better portability.
> o It would be nice to have some fault-injection in test code to verify that
>   CONFIG_DEBUG_RBTREE and CONFIG_DEBUG_RBTREE_VALIDATE (and it's
>   RB_VERIFY_INTEGRITY counterpart flag) catch the errors they are supposed to.
>
> Undecided (Opinions Requested!)
> -------------------------------
> o With the exception of the rb_node & rb_root structs, "Layer 2" of the code
>   (see below) completely abstracts away the underlying red-black tree
>   mechanism.  The structs rb_node and rb_root can also be abstracted away via
>   a typeset or some other mechanism. Thus, should the "Layer 2" code be
>   separated from "Layer 1" and renamed "Generic Tree (gtree)" or some such,
>   paving the way for an alternate tree implementation in the future?
> o Do we need RB_INSERT_DUPE_RIGHT? (see the last patch)
>
>
> Theory of Operation
> ===================
> Historically, genericity in C meant function pointers, the overhead of a
> function call and the inability of the compiler to optimize code across
> the function call boundary.  GCC has been getting better and better at
> optimization and determining when a value is a compile-time constant and
> compiling it out.  As of gcc 4.6, it has finally reached a point where
> it's possible to have generic search & insert cores that optimize
> exactly as well as if they were hand-coded. (see also gcc man page:
> -findirect-inlining)
>
> This implementation actually consists of two layers written on top of the
> existing rbtree implementation.
>
> Layer 1: Type-Specific (But Not Type-Safe)
> ------------------------------------------
> The first layer consists of enum rb_flags, struct rb_relationship and
> some generic inline functions(see patch for doc comments).
>
> enum rb_flags {
> 	RB_HAS_LEFTMOST		= 0x00000001,
> 	RB_HAS_RIGHTMOST	= 0x00000002,
> 	RB_HAS_COUNT		= 0x00000004,
> 	RB_UNIQUE_KEYS		= 0x00000008,
> 	RB_INSERT_REPLACES	= 0x00000010,
> 	RB_IS_AUGMENTED		= 0x00000040,
> 	RB_VERIFY_USAGE		= 0x00000080,
> 	RB_VERIFY_INTEGRITY	= 0x00000100
> };
>
> struct rb_relationship {
> 	ssize_t root_offset;
> 	ssize_t left_offset;
> 	ssize_t right_offset;
> 	ssize_t count_offset;
> 	ssize_t node_offset;
> 	ssize_t key_offset;
> 	int flags;
> 	const rb_compare_f compare;     /* comparitor for lookups */
> 	const rb_compare_f ins_compare; /* comparitor for inserts */
> 	const rb_augment_f augment;
> 	unsigned key_size;
> };
>
> /* these function for use on all trees */
> struct rb_node *rb_find(
> 		struct rb_root *root,
> 		const void *key,
> 		const struct rb_relationship *rel);
> struct rb_node *rb_find_near(
> 		struct rb_node *from,
> 		const void *key,
> 		const struct rb_relationship *rel);
> struct rb_node *rb_insert(
> 		struct rb_root *root,
> 		struct rb_node *node,
> 		const struct rb_relationship *rel);
> struct rb_node *rb_insert_near(
> 		struct rb_root *root,
> 		struct rb_node *start,
> 		struct rb_node *node,
> 		const struct rb_relationship *rel);
> void rb_remove(	struct rb_root *root,
> 		struct rb_node *node,
> 		const struct rb_relationship *rel);
>
> /* these function for use on trees with non-unique keys */
> struct rb_node *rb_find_first(
> 		struct rb_root *root,
> 		const void *key,
> 		const struct rb_relationship *rel);
> struct rb_node *rb_find_last(
> 		struct rb_root *root,
> 		const void *key,
> 		const struct rb_relationship *rel);
> struct rb_node *rb_find_next(
> 		const struct rb_node *node,
> 		const struct rb_relationship *rel)
> struct rb_node *rb_find_prev(
> 		const struct rb_node *node,
> 		const struct rb_relationship *rel)
>
> Using this layer involves initializing a const struct rb_relationship
> variable with compile-time constant values and feeding its "address" to
> the generic inline functions.  The trick being, that (when gcc behaves
> properly) it never creates a struct rb_relationship variable, stores an
> initializer in the data section of the object file or passes a struct
> rb_relationship pointer.  Instead, gcc "optimizes out" out the struct,
> and uses the compile-time constant values to dictate how the inline
> functions will expand.
>
> Thus, this structure can be thought of both as a database's DDL (data
> definition language), defining the relationship between two entities and the
> template parameters to a C++ templatized function that controls how the
> template function is instantiated.  This creates type-specific functions,
> although type-safety is still not achieved (e.g., you can pass a pointer to
> any rb_node you like).
>
> To simplify usage, you can initialize your struct rb_relationship variable
> with the RB_RELATIONSHIP macro, feeding it your types, member names and flags
> and it will calculate the offsets for you.  See doc comments in patch for
> examples of using this layer (either with or without the RB_RELATIONSHIP
> macro).
>
> Layer 2: Type-Safety
> --------------------
> In order to achieve type-safety of a generic interface in C, we must delve
> deep into the darkened Swamps of The Preprocessor and confront the Prince of
> Darkness himself: Big Ugly Macro.  To be fair, there is an alternative
> solution (discussed in History & Design Goals), the so-called "x-macro" or
> "supermacro" where you #define some pre-processor values and include an
> unguarded header file.  With 17 parameters, I choose this solution for its
> ease of use and brevity, but it's an area worth debate (some of which you can
> find here if you wish: http://lwn.net/Articles/501876).
>
> So this second layer allows you to use a single macro to define your
> relationship as well as type-safe wrapper functions all in one go.
>
> RB_DEFINE_INTERFACE(
> 	prefix,
> 	cont_type, root, left, right, count,
> 	obj_type, node, key,
> 	flags, compare, ins_compare, augment,
> 	find_mod, insert_mod, find_near_mod, insert_near_mod)
>
> To avoid needing multiple versions of the macro, we use a paradigm where
> optional values can be left empty. (See RB_DEFINE_INTERFACE doc comments for
> details.)  Thus, if your container doesn't need to know leftmost, you leave
> the parameter empty.  Here's a quick example:
>
> struct container {
> 	struct rb_root root;
> 	struct rb_node *leftmost;
> 	unsigned long count;
> };
>
> struct object {
> 	struct rb_node node;
> 	long key;
> };
>
> static inline long compare_long(const long *a, const long *b)
> {
> 	return *a - *b;
> }
>
> RB_DEFINE_INTERFACE(
> 	my_objects,
> 	struct container, root, leftmost, /* no rightmost */, count,
> 	struct object, node, key,
> 	RB_UNIQUE_KEYS | RB_INSERT_REPLACES, compare_long, compare_long,
> 	/* no augment */,
> 	,,,)
>
> This will do some type-checking, create the struct rb_relationship and
> the following static __always_inline wrapper functions. (Note that
> "my_objects" is the prefix used in the example above.  It will be
> whatever you pass as the first parameter to the RB_DEFINE_INTERFACE
> macro.)
>
> struct object *my_objects_find(
> 		struct container *cont,
> 		const typeof(((struct object *)0)->key) *_key);
> struct object *my_objects_insert(
> 		struct container *cont,
> 		struct object *obj);
> struct object *my_objects_find_near(
> 		struct object *near,
> 		const typeof(((struct object *)0)->key) *_key);
> struct object *my_objects_insert_near(
> 		struct container *cont,
> 		struct object *near,
> 		struct object *obj);
> void my_objects_remove(struct container *cont, struct object *obj);
> struct object *my_objects_find_first(
> 		struct container *cont,
> 		const typeof(((struct object *)0)->key) *_key);
> struct object *my_objects_find_last(
> 		struct container *cont,
> 		const typeof(((struct object *)0)->key) *_key);
> struct object *my_objects_find_next(const struct object *obj);
> struct object *my_objects_find_last(const struct object *obj);
> struct object *my_objects_next(const struct object *obj);
> struct object *my_objects_prev(const struct object *obj);
> struct object *my_objects_first(struct container *cont);
> struct object *my_objects_last(struct container *cont);
>
> Each of these are each declared static __always_inline. However, you can
> change the modifiers for the first four (find, insert, find_near and
> insert_near) by populating any of the last 4 parameters with the function
> modifiers of the respective function (when empty, they default to static
> __always_inline).
>
> Not only does this layer give you type-safety, it removes almost all of
> the implementation details of the rbtree from the code using it, thus
> making it easier to replace the underlying algorithm at some later
> date.
>
> Compare Functions
> -----------------
> Because equality is unimportant when doing inserts into a tree with duplicate
> keys, struct rb_relationship's ins_compare field can be set to a greater-than
> function for better performance. Using the example in the section above as a
> model, this is what it would look like:
>
> static inline long compare_long(const long *a, const long *b)
> ...
> static inline long greater_long(const long *a, const long *b)
> {
> 	return *a > *b;
> }
>
> RB_DEFINE_INTERFACE(
> 	my_objects,
> 	struct container, root, leftmost, /* no rightmost */, count,
> 	struct object, node, key,
> 	0, compare_long, greater_long,
> 	/* no augment */,
> 	,,,)
>
>
> History & Design Goals
> ======================
> I've been through many iterations of various techniques searching for the
> perfect "clean" implementation and finally settled on having a huge macro
> expand to wrapper functions after exhausting all other alternatives. The trick
> is that what one person considers a "clean" implementation is a bit of a value
> judgment.  So by "clean", I mean balancing these requirements:
>
> 1.) minimal dependence on pre-processor
> 2.) avoiding pre-processor expanded code that will break debug
>     information (backtraces)
> 3.) optimal encapsulation of the details of your rbtree in minimal
>     source code (this is where you define the relationship between your
> 	container and contained objects, their types, keys, rather or not
> 	non-unique objects are allowed, etc.) -- preferably eliminating
> 	duplication of these details entirely.
> 4.) offering a complete feature-set in a single implementation (not
>     multiple functions when various features are used)
> 5.) perfect optimization -- the generic function must be exactly as
>     efficient as the hand-coded version
>
> By those standards, the "cleanest" implementation I had come up with
> actually used a different mechanism: defining an anonymous interface
> struct something like this:
>
> /* generic non-type-safe function */
> static __always_inline void *__generic_func(void *obj);
>
> struct {							\
>         out_type *(*const func)(in_type *obj);			\
> } name = {							\
>         .func = (out_type *(*const)(in_type *obj))__generic_func;\
> }
>
> /* usage looks like this: */
> DEFINE_INTERFACE(solution_a, struct something, struct something_else);
> struct something *s;
> struct something_else *se;
> se = solution_a.func(s);
>
> Sadly, while solution_a.func(s) optimizes perfectly in 4.6, it completely
> bombed in 4.5 and prior -- the call by struct-member-function-pointer is never
> inlined and nothing passed to it is every considered a compile-time constant
> (again, see gcc's docs on -findirect-inline).  Because of the implementation
> of the generic functions, this bloated the code unacceptably (3x larger).
> Thus, I finally settled on the current RB_DEFINE_INTERFACE macro, which is
> massive, but optimizes perfectly in 4.6+ and close enough in 4.5 and prior
> (prior to 4.6, the compare function is never inlined).
>
> The other alternative I briefly considered was to have a header file
> that is only included after #defining all of these parameters, relying
> primarily on cpp rather than cc & compile-time constants to fill in the
> relationship details (the "x-macro" approach).  While this mechanism
> would perform better on older compilers and never break backtraces, in
> the end, I just couldn't stomach it.  Aside from that, it would make
> using the interface almost as verbose as hand-coding it yourself.
>
> Performance
> ===========
> Here are the results of performance tests run on v5 of this patch set (against
> v3.5 kernel) on an AMD Phenom 9850.  This is a reformatted version of what
> tools/testing/selftests/grbtree/user/gen_report.sh outputs.  Test results vary
> quite a bit dependent upon the selected features.
>
> For all of these tests, I used the following parameters:
> key range       0-4095
> key type	u32
> object_count    2048
> repititions     131,072
> node_size       24 bytes
> object_size     32 bytes
> total data size 65,536 bytes
> num insertions	268,435,456
>
> Below is a summary of the performance drop using generic rbtrees on various
> ranges of compilers. (negative values are performance improvements)
>
> GCC versions    Best    Worst
> 3.4 - 4.0	35%	80%
> 4.1 - 4.5	18%	23%
> 4.6 - 4.7	-7%	 5%
>
> The tables below list the time in seconds it took to execute the tests on each
> compiler and the difference between the generic and specific (i.e.,
> hand-coded) test results.
>
> Duplicate keys (no leftmost, rightmost or count)
> Compiler       Generic Specific Performance Loss
> gcc-3.4.6	33.41	18.78	77.94%
> gcc-4.0.4	32.36	17.94	80.37%
> gcc-4.1.2	23.11	17.76	30.14%
> gcc-4.2.4	22.97	17.83	28.84%
> gcc-4.3.6	23.07	17.78	29.79%
> gcc-4.4.7	21.88	17.64	24.03%
> gcc-4.5.4	21.75	17.54	23.99%
> gcc-4.6.3	16.84	16.82	 0.10%
> gcc-4.7.1	16.79	16.68	 0.66%
>
> Duplicate keys, use leftmost (no rightmost or count)
> Compiler       Generic Specific Performance Loss
> gcc-3.4.6	33.54	22.57	48.63%
> gcc-4.0.4	32.82	22.16	48.07%
> gcc-4.1.2	27.30	22.77	19.93%
> gcc-4.2.4	27.41	22.86	19.95%
> gcc-4.3.6	28.65	23.03	24.38%
> gcc-4.4.7	27.03	21.41	26.24%
> gcc-4.5.4	26.69	22.48	18.71%
> gcc-4.6.3	21.58	21.53	 0.24%
> gcc-4.7.1	22.40	22.23	 0.77%
>
> Duplicate keys, use leftmost, rightmost and count
> Compiler       Generic Specific Performance Loss
> gcc-3.4.6	33.49	22.70	47.52%
> gcc-4.0.4	33.19	23.71	39.94%
> gcc-4.1.2	29.03	23.76	22.18%
> gcc-4.2.4	28.59	23.82	20.04%
> gcc-4.3.6	29.69	23.94	24.01%
> gcc-4.4.7	28.62	23.89	19.79%
> gcc-4.5.4	28.73	23.54	22.04%
> gcc-4.6.3	23.82	23.70	 0.51%
> gcc-4.7.1	23.84	23.94	-0.40%
>
> Unique keys (no leftmost, rightmost or count)
> Compiler       Generic Specific Performance Loss
> gcc-3.4.6	29.38	19.94	47.33%
> gcc-4.0.4	28.85	21.14	36.48%
> gcc-4.1.2	25.16	20.30	23.95%
> gcc-4.2.4	25.26	20.50	23.23%
> gcc-4.3.6	25.41	20.82	22.02%
> gcc-4.4.7	26.12	20.68	26.33%
> gcc-4.5.4	25.29	20.31	24.54%
> gcc-4.6.3	21.57	20.35	 6.01%
> gcc-4.7.1	20.98	20.20	 3.88%
>
> Unique keys, use leftmost (no rightmost or count)
> Compiler       Generic Specific Performance Loss
> gcc-3.4.6	29.50	20.96	40.76%
> gcc-4.0.4	28.93	20.90	38.41%
> gcc-4.1.2	26.26	22.29	17.80%
> gcc-4.2.4	25.49	22.05	15.61%
> gcc-4.3.6	26.55	22.25	19.34%
> gcc-4.4.7	28.90	22.24	29.92%
> gcc-4.5.4	26.85	21.86	22.80%
> gcc-4.6.3	22.95	22.06	 4.03%
> gcc-4.7.1	22.56	21.48	 5.01%
>
> Unique keys, use leftmost, rightmost and count
> Compiler       Generic Specific Performance Loss
> gcc-3.4.6	29.48	20.91	40.97%
> gcc-4.0.4	29.37	21.72	35.20%
> gcc-4.1.2	25.25	23.10	 9.29%
> gcc-4.2.4	26.17	22.35	17.13%
> gcc-4.3.6	26.34	22.30	18.10%
> gcc-4.4.7	25.24	22.43	12.51%
> gcc-4.5.4	25.58	23.07	10.89%
> gcc-4.6.3	21.79	23.50	-7.29%
> gcc-4.7.1	23.27	25.08	-7.22%
>
>
> I've done an analysis of the gcc 4.7.1-generated code and discovered the
> following flaws in the generic insert function.
>
> 1. Key of inserted object being read repeatedly. Instead of reading the value
>    of the inserted key once, at the start of the function, the key is read
>    prior to each comparision.  I'm guessing that this is because optimizer
>    makes the faulty assumption that the value could change throughout the
>    course of execution. This costs us one extra instruction each iteration of
>    the loop as we search the tree (32-bit key).
>
>      mov    0x18(%rax),%edx
>
>    A work-around is in place to eliminate this problem on gcc 4.6.0 and later
>    if your key size is 16, 32 or 64 bits, which manages to get gcc to store
>    the key of the supplied object in a regsiter at the start of the function
>    preventing us a performance loss of roughly 4%.
>
> 2. Due to gcc bug 3507 (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3507),
>    this code:
>
>      long diff = a - b;
>
>      if (diff > 0)
>          do_gt();
>      else if (diff < 0)
>          do_lt();
>      else
>          do_eq();
>
>    Optimizes more poorly than this code:
>
>      if (a > b)
>          do_gt();
>      else if (b < a)
>          do_lt();
>      else
>          do_eq();
>
>    So instead of the key compare happening like this (64-bit key):
>
>      cmp    0x18(%rax),%rsi
>
>    We get this:
>
>      mov    %rsi,%rdx
>      sub    0x18(%rax),%rdx
>      cmp    $0x0,%rdx
>
>    The results can be slightly worse when the key type isn't the same as long.
>    With a signed 32-bit key (s32) on x86_64, gcc thinks it needs to convert
>    the difference to a 64-bit long.
>
>      mov    %esi,%edx
>      sub    0x18(%rax),%edx
>      movslq %edx,%rdx
>      cmp    $0x0,%rdx
>
>    Not only is this 2-3 extra instruction, it also uses one extra register,
>    which in turn forces gcc to use an r8-15 register in other places, which
>    requires larger opcodes. Also, this only occurs when using the normal
>    compare function (doesn't occur when using 'greater').  So this affects
>    inserts on trees with unique keys and all lookups.
>
> Q&A
> ===
> Q: Why did you add BUILD_BUG_ON_NON_CONST() and
>    BUILD_BUG_ON_NON_CONST42()?
> A: There were initially enough BUILD_BUG_ON(!__builtin_constant_p(arg))
>    calls to warrant it having a macro for it.  However, I've since
>    discovered that using __builtin_constant_p on a struct member did not
>    behave very consistently, so after writing some test programs &
>    scripts, and refining 200k+ test results, I graphed out basically
>    where __builtin_constant_p() worked and didn't.  As it turns out,
>    using it on struct members is fragile until gcc 4.2, so
>    BUILD_BUG_ON_NON_CONST42() is intended for use with struct members.
>
> Q: Why empty parameters?
>    What is IFF_EMPTY() for?
>    Why don't you just pass zero instead of an empty parameter?
> A: Support for caching the left- & right-most nodes in the tree as well
>    as maintaining a count variable are all optional.  Passing the offset
>    value directly not only means more characters of code to use the
>    RB_RELATIONSHIP and RB_DEFINE_INTERFACE macros (because now you'll
>    have to invoke the offsetof macro, supplying your struct types
>    again), but the offset may actually be zero, so passing zero as "I'm
>    not using this feature" wont work.  (This is the reason why the flags
>    RB_HAS_LEFTMOST, et. al. exist.)  Thus, you would also need to
>    manually pass the appropriate rb_flag value to specify that you're
>    using the feature.  All of this means more copy, paste & edit code
>    that is error-prone and a maintenance nightmare.  This implementation
>    allows the caller to pass the name of the struct member or leave the
>    parameter empty to mean "I'm not using this feature", thus
>    eliminating all of these other complications.
>
> Q: Using huge macro like RB_DEFINE_INTERFACE prone to usage errors that
>    create crappy error messages and have zero type-safety. (not really a
>    question)
> A: True.  However, much of this is mitigated by creating an
>    __rb_sanity_check_##name function that is never called, but will
>    generate meaningful error messages for most mistakes (incorrect
>    struct member types, etc.)
>
> Q: The traditional boolean comparitor passed to for sorted sets is a less_than
>    function, why are you using 'greater than'?
> A: This decision is purely for optimization purposes, as compare and
>    greather_than are interchangable when we don't care about equality.
>    However, this may become a moot point if we can't get gcc to properly
>    optimize code using the compare function, and switch to a pair of
>    equals/less functions.
>
> Revision History
> ===============
> New in v5
> o Added a ability to specify a different compare function for inserts.  This
>   is more efficient on trees with duplicate keys, since you can use a boolean
>   "greater than" function.
> o Added an optimization to generate better code where key size is 16, 32 or 64
>   bits.
> o Add test & validation framework (CONFIG_DEBUG_RBTREE and
>   CONFIG_DEBUG_RBTREE_VALIDATE)
> o Fixed bugs in kernel-doc so that API documentation generates correctly.
> o Add userspace test program & scripts.
> o Fixed a lot of typos
> o Cleaned up and completed kernel-doc comments
>
> New in v4:
> o Added type-safe wrapper functions for rb_{next,prev,first,last}
>   to RB_DEFINE_INTERFACE.  Naming is the same as other type-safe
>   functions (e.g.,  prefix##_first wraps rb_first). (thanks Pavel Pisa
>   for the suggestion)
> o Added rb_find_{first,next,last,prev} (for non-unique trees) to find
>   the first or last occurrence of a key and iterate through them.
>   Type-safe wrapper functions also added to RB_DEFINE_INTERFACE. (thanks
>   again Pavel Pisa)
> o Added support for an unsigned long count member of the container
>   struct that will be updated upon insertions & deletions.
> o Improve sanity checks performed by RB_DEFINE_INTERFACE -- error
>   messages are now more specific and clearer.  Type safety for compare
>   function is now enforced.
> o Completed implementation of insert_near (still untested).
> o Completed testing for find_near.  Performance is something like
>   O(log distance * 2 + 1), so if your start node is a bit closer than
>   half way across the tree, find_near will be about the same speed as
>   find. If it is further, it will be slower.  Either way, it is larger
>   than a normal find (which should be taken into account), so should
>   only be used when you are fairly certain your target objects is near
>   the start.
> o Added support for specifying modifiers for functions generated by
>   RB_DEFINE_INTERFACE.  This adds 4 more parameters, but is probably
>   better than forcing the user to write their own wrapper functions to
>   macro-generated wrapper functions, just to change their function
>   attributes.
> o Added run-time versions of all of the __rb_xxx_to_xxx inline
>   functions, for use in those conditions where someone may actually need
>   to access these using a run-time struct rb_relatinoship value.
> o Performed compile tests on gcc 3.4.6 - 4.7.0 and tweaked BUILD_BUG_ON*
>   macros to not fail on any of these compilers.
>
> New in v3:
> o Moved compare & augment functions back into struct rb_relationship
>   after discovering that calling them will be inlined in gcc 4.6+ if the
>   function is flattened.
> o Improved doc comments.
> o Solved problem of compare function not being checked for
>   type-correctness by adding a __sanity_check_##name() function to
>   __RB_DEFINE_INTERFACE that generates usable errors when there's a type
>   or member name problem in the macro parameters.  This is helpful since
>   the errors produced when the RB_RELATIONSHIP macro expands were quite
>   terrible.
>
> New in v2:
> o Added RB_RELATIONSHIP macro (thanks Peter Zijlstra for the
>   suggestions).
> o Added RB_DEFINE_INTERFACE macro.
>

