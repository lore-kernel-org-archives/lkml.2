Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341Ab2FGJNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:13:12 -0400
Received: from nm16-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.166]:28803
	"HELO nm16-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751176Ab2FGJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:13:09 -0400
X-Yahoo-Newman-Id: 619432.53969.bm@omp1016.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: U9CNbWMVM1l_7qSSUb8MKSBWVS_K7VfqVZ77EO7a_vcJbK.
 hT2a2Gkwwbi17MNBoq4ux0KrfHlsLd5gCwqCbIbn30rQje6UK1a5QfKSJ2m4
 F4rd7rNXTyz8O2UKzF_7P_zZ7BEMXfDGlhlQUYqMl6el5gmsHk6fPl2hEO6b
 1RFGvfwGcTBnItFnx2bJIYtZIlP_W7zsCBkrRL00JiGq.sQnqkdzLzCws8PY
 1cogwGTDjSpveQUAgYwp5wwI_8E6JMd_TszD7DB0LsBPcKukDUmGY_l.TZm9
 KUiD46qForgvdSrRq_mw5RAULYeTtThqH8Mt6jNjyG9z7zMhqhei3._Hth6l
 u_tvrwzp1VoOdvjWCJCxyYgqZHjML2ANJ66ufn.o2cMha0I6xWb3PcFlXGt8
 6biJ8UA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD070A7.8040505@att.net>
Date: Thu, 07 Jun 2012 04:13:11 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kent Overstreet <koverstreet@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, tj@kernel.org
Subject: [PATCH v3 0/6] [RFC] Generic Red-Black Trees: search, insert & remove
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off, I hope I have fixed my mailer issues.  Patches are now inline and (hopefully) non-mangled, so I would appreciate if somebody can let me know.

Summary
=======
This patch set improves on Andrea Arcangeli's original Red-Black Tree
implementation by adding generic search and insert functions with
complete support for:

o leftmost - keeps a pointer to the leftmost (lowest value) node cached
  in your container struct
o rightmost - ditto for rightmost (greatest value)
o unique or non-unique keys
o find and insert "near" functions - when you already have a node that
  is likely near another one you want to search for
o augmented / interval tree support
o type-safe wrapper interface available via pre-processor macro

Outstanding Issues
==================
o insert_near not finished
o find_near not yet tested
o augmented not yet tested
o doc comments incomplete
o doc generator doesn't like when you use var args to call another macro
  and then try to document those arguments that are passed.

Theory of Operation
===================
Historically, genericity in C meant function pointers, the overhead of a
function call and the inability of the compiler to optimize code across
the function call boundary.  GCC has been getting better and better at
optimization and determining when a value is a compile-time constant and
compiling it out.  As of gcc 4.6, it has finally reached a point where
it's possible to have generic search & insert cores that optimize
exactly as well as if they were hand-coded.

Using this API consists of populating a simple struct with compile-time
constant values. (see patch for doc comments)

struct rb_relationship {
	long root_offset;
	long left_offset;
	long right_offset;
	long node_offset;
	long key_offset;
	int flags;
	const rb_compare_f compare;
	const rb_augment_f augment;
};

A pointer to this object is then passed to each of the generic inline
functions and gcc optimizes it to your specification.  This structure
can be thought of both as a database's DDL (data definition language),
defining the relationship between two entities and the template
parameters to a C++ templatized function that controls how the template
function is instantiated.

To simplify usage, you can initialize your struct rb_relationship
variable with the RB_RELATIONSHIP macro, feeding it your types, member
names and flags and it will calculate the offsets for you.

Finally, a larger (uglier) macro exists that will define your
relationship as well as type-safe wrapper functions all in one go.
Here's a quick example:

struct container {
	struct rb_root root;
	struct rb_node *leftmost;
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
	struct container, root, leftmost, /* no rightmost */,
	struct object, node, key,
	RB_UNIQUE_KEYS | RB_INSERT_REPLACES, compare_long, 0)

This will do some type-checking, create the struct rb_relationship and
the following static __always_inline wrapper functions:

struct object *insert(struct container *cont, struct object *obj);
struct object *find(struct container *cont,
		    const typeof(((struct object *)0)->key) *_key);
struct object *insert_near(struct container *cont, struct object *near,
			   struct object *obj);
struct object *find_near(struct object *near,
			 const typeof(((struct object *)0)->key) *_key);
void remove(struct container *cont, struct object *obj);

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

/* gerneric non-type-safe function */
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

The other alternative I briefly considered as to have a header file that
is only included after #defining all of these parameters, relying
primarily on cpp rather than cc & compile-time constants to fill in the
relationship details.  While this mechanism would perform better on
older compilers, in the end, I just couldn't stomach it.  Aside from
that, it would make using the interface almost as verbose as hand-coding
it yourself.

Q&A
===
Q: Why did you add BUILD_BUG_ON_NON_CONST() and
   BUILD_BUG_ON_NON_CONST2()?
A: There were initially enough BUILD_BUG_ON(!__builtin_constant_p(arg))
   calls to warrant it having a macro for it.  However, I've since
   discovered that using __builtin_constant_p on a struct member did not
   behave very consistently, so after writing some test programs &
   scripts, and refining 200k+ test results, I graphed out basically
   where __builtin_constant_p() worked and didn't.  As it turns out,
   using it on struct members is fragile until gcc 4.4, so
   BUILD_BUG_ON_NON_CONST2() is intended for use with struct members (as
   well as array & pointer derefs).

Q: What is IFF_EMPTY() for?  Why don't you just pass zero instead of
   empty?
A: Support for caching the left-most and right-most nodes in the tree
   are both optional.  Passing the offset value directly not only means
   more chracters of code to use the RB_RELATIONHIP and
   RB_DEFINE_INTERFACE macros, but the offset may actually be zero, so
   passing zero as "I'm not using this feature" wont work.  This
   implementation allows the caller to either pass the name of the
   struct member or leave the parameter empty to mean "I'm not using
   this feature", thus eliminating the need for 4 separate copies of the
   macro or 2 extra parameters, just to specify rather or not the
   feature is being used.

Revision History
===============
New in v3:
o Moved compare & augment functions back into struct rb_relationship
  after discovering that calling them will be inlined in gcc 4.6+ if the
  function is flattened..
o Improved doc comments.
o Solved problem of compare function not being checked for
  type-correctness by adding a _sanity_check_##name() function to
  __RB_DEFINE_INTERFACE that generates useable errors when there's a
  type or member name problem in the macro parameters.  This is helpful
  since the errors produced when the RB_RELATIONHIP macro expands were
  quite terrible..

New in v2:
o Added RB_RELATIONSHIP macro (thanks Peter Zijlstra for the
  suggestions).
o Added RB_DEFINE_INTERFACE macro.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>

