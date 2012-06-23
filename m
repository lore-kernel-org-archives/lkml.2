Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab2FWEBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:01:23 -0400
Received: from nm2-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.66]:22555
	"HELO nm2-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750810Ab2FWEBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:01:21 -0400
X-Yahoo-Newman-Id: 856630.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VWHH8t8VM1k1uawT8ksALTqRNZynx52RKOf2ZDTbheM9rZC
 MusrS5T1GWjSp8D0KnnErz1jom3XUZuqQEDin.SxLDSiEhWb88cIKxyxq90K
 0e0Qe1k4MUV1E7trlAcRj9YrXFYIffXdMCf.LiBopu42_HSJTaZ2URKT87.g
 2RA0Zghi0Lo6r_3j1RgX_27UlDDILZleUsTme11Wmz3fp2qKyoJOhGVRtWD_
 QSk_m7VhNaVCdPfMAo1WFmwfWg.B88EI42T23dEsvsG0blx_W0.dO1VlnGDS
 tQhsMixuz3VR4U2JQsp11wD2SE0TGOzzdsaMTZnY63CymiYB5PVFrGVUnWQl
 0BfkShIVaWo7Zcf_6ftQeR7R4Ru6lmG9y37i5S4AO_8eXtm8BgwtosGe6wUV
 GLzG_Ta5alyaYg7IhLK9HwLC2TDPt1yeqgWmEJ3o8kfUtldaBlYQ65H6lhnJ
 54fu8P9QzYhUtaaF9motI_fZRnDxK7fHPd_uOqqLS78ktyoBpXWuLz8RuIDL
 T
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 0/13] Generic Red-Black Trees
Date: Fri, 22 Jun 2012 23:00:35 -0500
Message-Id: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Documentation/DocBook/kernel-api.tmpl |    4 +
 include/linux/bug.h                   |  109 +++-
 include/linux/compiler-gcc.h          |    3 +
 include/linux/compiler-gcc3.h         |    8 +-
 include/linux/compiler-gcc4.h         |   31 +-
 include/linux/compiler.h              |    7 +-
 include/linux/rbtree.h                | 1044 ++++++++++++++++++++++++-
 kernel/sched/fair.c                   |   82 +--
 8 files changed, 1200 insertions(+), 88 deletions(-)


Summary
=======
This patch set improves on Andrea Arcangeli's original Red-Black Tree
implementation by adding generic search and insert functions with
complete support for:

o leftmost - keeps a pointer to the leftmost (lowest value) node cached
  in your container struct
o rightmost - ditto for rightmost (greatest value)
o count - optionally update an count variable when you perform inserts
  or deletes
o unique or non-unique keys
o find and insert "near" functions - when you already have a node that
  is likely near another one you want to search for
o augmented / interval tree support
o type-safe wrapper interface available via pre-processor macro

Outstanding Issues
==================
o insert_near yet not tested
o find_near needs retesting
o find_{first,last,next,prev} untested
o augmented not yet tested
o doc comments still incomplete (but closer)
o need complete test module to perform tests for:
  - correctness - test all functions & scenarios and verify results are
    correct
  - performance - compare generic functions with with hand-coded
    versions to verify performance differences (or lack there of) on
    various compilers and archs
o add CONFIG_RBTREE_DEBUG option (or similar) to check for usage
  problems at run-time.
o need a new home for the general-purpose macros: IFF_EMPTY(), IS_EMPTY()
  and OPT_OFFSETOF() (possibly in stddef.h?)

Theory of Operation
===================
Historically, genericity in C meant function pointers, the overhead of a
function call and the inability of the compiler to optimize code across
the function call boundary.  GCC has been getting better and better at
optimization and determining when a value is a compile-time constant and
compiling it out.  As of gcc 4.6, it has finally reached a point where
it's possible to have generic search & insert cores that optimize
exactly as well as if they were hand-coded. (see also gcc man page:
-findirect-inlining)

This implementation actually consists of two layers written on top of the
existing rbtree implementation.

Layer 1: Type-Specific (But Not Type-Safe)
------------------------------------------
The first layer consists of enum rb_flags, struct rb_relationship and
some generic inline functions(see patch for doc comments).

enum rb_flags {
	RB_HAS_LEFTMOST	   = 0x00000001,
	RB_HAS_RIGHTMOST   = 0x00000002,
	RB_HAS_COUNT	   = 0x00000004,
	RB_UNIQUE_KEYS	   = 0x00000008,
	RB_INSERT_REPLACES = 0x00000010,
	RB_IS_AUGMENTED	   = 0x00000020,
};

struct rb_relationship {
	ssize_t root_offset;
	ssize_t left_offset;
	ssize_t right_offset;
	ssize_t count_offset;
	ssize_t node_offset;
	ssize_t key_offset;
	int flags;
	const rb_compare_f compare;
	const rb_augment_f augment;
};

/* these function for use on all trees */
struct rb_node *rb_find(
		struct rb_root *root,
		const void *key,
		const struct rb_relationship *rel);
struct rb_node *rb_find_near(
		struct rb_node *from,
		const void *key,
		const struct rb_relationship *rel);
struct rb_node *rb_insert(
		struct rb_root *root,
		struct rb_node *node,
		const struct rb_relationship *rel);
struct rb_node *rb_insert_near(
		struct rb_root *root,
		struct rb_node *start,
		struct rb_node *node,
		const struct rb_relationship *rel);
void rb_remove(	struct rb_root *root,
		struct rb_node *node,
		const struct rb_relationship *rel);

/* these function for use on trees with non-unique keys */
struct rb_node *rb_find_first(
		struct rb_root *root,
		const void *key,
		const struct rb_relationship *rel);
struct rb_node *rb_find_last(
		struct rb_root *root,
		const void *key,
		const struct rb_relationship *rel);
struct rb_node *rb_find_next(
		const struct rb_node *node,
		const struct rb_relationship *rel)
struct rb_node *rb_find_prev(
		const struct rb_node *node,
		const struct rb_relationship *rel)

Using this layer involves initializing a const struct rb_relationship
variable with compile-time constant values and feeding its "address" to
the generic inline functions.  The trick being, that (when gcc behaves
properly) it never creates a struct rb_relationship variable, stores an
initializer in the data section of the object file or passes a struct
rb_relationship pointer.  Instead, gcc "optimizes out" out the struct,
and uses the compile-time constant values to dictate how the inline
functions will expand.

Thus, this structure can be thought of both as a database's DDL (data
definition language), defining the relationship between two entities and
the template parameters to a C++ templatized function that controls how
the template function is instantiated.  This creates type-specific
functions, although type-safety is still not achieved (e.g., you can
pass a pointer to any rb_node you like).

To simplify usage, you can initialize your struct rb_relationship
variable with the RB_RELATIONSHIP macro, feeding it your types, member
names and flags and it will calculate the offsets for you.  See doc
comments in patch for examples of using this layer (either with or
without the RB_RELATIONSHIP macro).

Layer 2: Type-Safety
--------------------
In order to achieve type-safety of a generic interface in C, we must
delve deep into the darkened Swamps of The Preprocessor and confront the
Prince of Darkness himself: Big Ugly Macro.  To be fair, there is an
alternative solution (discussed in History & Design Goals), the
so-called "x-macro" or "supermacro" where you #define some pre-processor
values and include an unguarded header file.  With 17 parameters, I
choose this solution for its ease of use and brevity, but it's an area
worth debate.

So this second layer allows you to use a single macro to define your
relationship as well as type-safe wrapper functions all in one go.

RB_DEFINE_INTERFACE(
	prefix,
	cont_type, root, left, right, count,
	obj_type, node, key,
	flags, compare, augment,
	find_mod, insert_mod, find_near_mod, insert_near_mod)

To avoid needing multiple versions of the macro, we use a paradigm where
optional values can be left empty. (See RB_DEFINE_INTERFACE doc comments
for details.)  Thus, if your container doesn't need to know leftmost,
you leave the parameter empty.  Here's a quick example:

struct container {
	struct rb_root root;
	struct rb_node *leftmost;
	unsigned long count;
};

struct object {
	struct rb_node node;
	long key;
};

static inline long compare_long(long *a, long *b)
{
	return *a - *b;
}

RB_DEFINE_INTERFACE(
	my_objects,
	struct container, root, leftmost, /* no rightmost */, count,
	struct object, node, key,
	RB_UNIQUE_KEYS | RB_INSERT_REPLACES, compare_long,
	/* no augment */,
	,,,)

This will do some type-checking, create the struct rb_relationship and
the following static __always_inline wrapper functions. (Note that
"my_objects" is the prefix used in the example above.  It will be
whatever you pass as the first parameter to the RB_DEFINE_INTERFACE
macro.)

struct object *my_objects_find(
		struct container *cont,
		const typeof(((struct object *)0)->key) *_key);
struct object *my_objects_insert(
		struct container *cont,
		struct object *obj);
struct object *my_objects_find_near(
		struct object *near,
		const typeof(((struct object *)0)->key) *_key);
struct object *my_objects_insert_near(
		struct container *cont,
		struct object *near,
		struct object *obj);
void my_objects_remove(struct container *cont, struct object *obj);
struct object *my_objects_find_first(
		struct container *cont,
		const typeof(((struct object *)0)->key) *_key);
struct object *my_objects_find_last(
		struct container *cont,
		const typeof(((struct object *)0)->key) *_key);
struct object *my_objects_find_next(const struct object *obj);
struct object *my_objects_find_last(const struct object *obj);
struct object *my_objects_next(const struct object *obj);
struct object *my_objects_prev(const struct object *obj);
struct object *my_objects_first(struct container *cont);
struct object *my_objects_last(struct container *cont);

Each of these are each declared static __always_inline. However, you can
change the modifiers for the first four (find, insert, find_near and
insert_near) by populate any of the last 4 parameters with the function
modifiers of the respective function (when empty, they default to static
__always_inline).

Not only does this layer give you type-safety, it removes almost all of
the implementation details of the rbtree from the code using it, thus
making it easier to replace the underlying algorithm at some later
date.

History & Design Goals
======================
I've been through many iterations of various techniques searching for
the perfect "clean" implementation and finally settled on having a huge
macro expand to wrapper functions after exhausting all other
alternatives. The trick is that what one person considers a "clean"
implementation is a bit of a value judgment.  So by "clean", I mean
balancing these requirements:

1.) minimal dependence on pre-processor
2.) avoiding pre-processor expanded code that will break debug
    information (backtraces)
3.) optimal encapsulation of the details of your rbtree in minimal
    source code (this is where you define the relationship between your
    container and contained objects, their types, keys, rather or not
    non-unique objects are allowed, etc.) -- preferably eliminating
    duplication of these details entirely.
4.) offering a complete feature-set in a single implementation (not
    multiple functions when various features are used)
5.) perfect optimization -- the generic function must be exactly as
    efficient as the hand-coded version

By those standards, the "cleanest" implementation I had come up with
actually used a different mechanism: defining an anonymous interface
struct something like this:

/* generic non-type-safe function */
static __always_inline void *__generic_func(void *obj);

struct {							\
        out_type *(*const func)(in_type *obj);			\
} name = {							\
        .func = (out_type *(*const)(in_type *obj))__generic_func;\
}

/* usage looks like this: */
DEFINE_INTERFACE(solution_a, struct something, struct something_else);
struct something *s;
struct something_else *se;
se = solution_a.func(s);

Sadly, while solution_a.func(s) optimizes perfectly in 4.6, it
completely bombed in 4.5 and prior -- the call by
struct-member-function-pointer is never inlined and nothing passed to it
is every considered a compile-time constant.  Because of the
implementation of the generic functions, this bloated the code
unacceptably (3x larger).  Thus, I finally settled on the current
RB_DEFINE_INTERFACE, which is massive, but optimizes perfectly in 4.6+
and close enough in 4.5 and prior (prior to 4.6, the compare function is
never inlined).

The other alternative I briefly considered was to have a header file
that is only included after #defining all of these parameters, relying
primarily on cpp rather than cc & compile-time constants to fill in the
relationship details (the "x-macro" approach).  While this mechanism
would perform better on older compilers and never break backtraces, in
the end, I just couldn't stomach it.  Aside from that, it would make
using the interface almost as verbose as hand-coding it yourself.

Q&A
===
Q: Why did you add BUILD_BUG_ON_NON_CONST() and
   BUILD_BUG_ON_NON_CONST42()?
A: There were initially enough BUILD_BUG_ON(!__builtin_constant_p(arg))
   calls to warrant it having a macro for it.  However, I've since
   discovered that using __builtin_constant_p on a struct member did not
   behave very consistently, so after writing some test programs &
   scripts, and refining 200k+ test results, I graphed out basically
   where __builtin_constant_p() worked and didn't.  As it turns out,
   using it on struct members is fragile until gcc 4.2, so
   BUILD_BUG_ON_NON_CONST42() is intended for use with struct members.

Q: Why empty parameters?
   What is IFF_EMPTY() for?
   Why don't you just pass zero instead of an empty parameter?
A: Support for caching the left- & right-most nodes in the tree as well
   as maintaining a count variable are all optional.  Passing the offset
   value directly not only means more characters of code to use the
   RB_RELATIONSHIP and RB_DEFINE_INTERFACE macros (because now you'll
   have to invoke the offsetof macro, supplying your struct types
   again), but the offset may actually be zero, so passing zero as "I'm
   not using this feature" wont work.  (This is the reason why the flags
   RB_HAS_LEFTMOST, et. al. exist.)  Thus, you would also need to
   manually pass the appropriate rb_flag value to specify that you're
   using the feature.  All of this means more copy, paste & edit code
   that is error-prone and a maintenance nightmare.  This implementation
   allows the caller to pass the name of the struct member or leave the
   parameter empty to mean "I'm not using this feature", thus
   eliminating all of these other complications.

Q: Using huge macro like RB_DEFINE_INTERFACE prone to usage errors that
   create crappy error messages and have zero type-safety. (not really a
   question)
A: True.  However, much of this is mitigated by creating an
   __rb_sanity_check_##name function that is never called, but will
   generate meaningful error messages for most mistakes (incorrect
   struct member types, etc.)

Revision History
===============
New in v4:
o Added type-safe wrapper functions for rb_{next,prev,first,last}
  to RB_DEFINE_INTERFACE.  Naming is the same as other type-safe
  functions (e.g.,  prefix##_first wraps rb_first). (thanks Pavel Pisa
  for the suggestion)
o Added rb_find_{first,next,last,prev} (for non-unique trees) to find
  the first or last occurrence of a key and iterate through them.
  Type-safe wrapper functions also added to RB_DEFINE_INTERFACE. (thanks
  again Pavel Pisa)
o Added support for an unsigned long count member of the container
  struct that will be updated upon insertions & deletions.
o Improve sanity checks performed by RB_DEFINE_INTERFACE -- error
  messages are now more specific and clearer.  Type safety for compare
  function is now enforced.
o Completed implementation of insert_near (still untested).
o Completed testing for find_near.  Performance is something like
  O(log distance * 2 + 1), so if your start node is a bit closer than
  half way across the tree, find_near will be about the same speed as
  find. If it is further, it will be slower.  Either way, it is larger
  than a normal find (which should be taken into account), so should
  only be used when you are fairly certain your target objects is near
  the start. (code was changed since this, so it needs re-testing)
o Added support for specifying modifiers for functions generated by
  RB_DEFINE_INTERFACE.  This adds 4 more parameters, but is probably
  better than forcing the user to write their own wrapper functions to
  macro-generated wrapper functions, just to change their function
  attributes.
o Added run-time versions of all of the __rb_xxx_to_xxx inline
  functions, for use in those conditions where someone may actually need
  to access these using a run-time struct rb_relatinoship value.
o Performed compile tests on gcc 3.4.6 - 4.7.0 and tweaked BUILD_BUG_ON*
  macros to not fail on any of these compilers.

New in v3:
o Moved compare & augment functions back into struct rb_relationship
  after discovering that calling them will be inlined in gcc 4.6+ if the
  function is flattened.
o Improved doc comments.
o Solved problem of compare function not being checked for
  type-correctness by adding a __sanity_check_##name() function to
  __RB_DEFINE_INTERFACE that generates usable errors when there's a type
  or member name problem in the macro parameters.  This is helpful since
  the errors produced when the RB_RELATIONSHIP macro expands were quite
  terrible.

New in v2:
o Added RB_RELATIONSHIP macro (thanks Peter Zijlstra for the
  suggestions).
o Added RB_DEFINE_INTERFACE macro.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>


