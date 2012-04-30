Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2D3LLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:11:31 -0400
Received: from nm27.bullet.mail.sp2.yahoo.com ([98.139.91.97]:22680 "HELO
	nm27.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756154Ab2D3LL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:11:29 -0400
X-Yahoo-Newman-Id: 268390.97696.bm@omp1025.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HBrGNioVM1lcS0JLy3VrxoLYTttrPbAcCv74ycLJ5_Q0EbQ
 gXXs_gRJ4GUqjeG7nxVmLNLTibF7KfNgwyPH3ABvJuXgDASoJFFmcBiM_KG.
 DKg5Yq.FxOH.yNk3Jgi7w2oarxHXco5tuvkimqLjMPgkCyFPdRtNY21F6xDr
 PEYefJh97rBLzBPgeZeGrnO.oBEVl6Rrry9iUXB2BMYq6G6WqhPxuxLtYLjI
 avDd76vV8GfQdGkfnVwjWzq7MJ1xm42FHppt95XE90iwRIhCHOhF.SPaSxTJ
 aLUfpFdUFx0DvbL7zQksfvG9NKnWjJX6.W6X1mV.p9KTnT0Pw3u6mhPy6ytd
 aOQdEBdCCXH8dXWFRSerXu5dn6MF21suCoLaXQyjhwSiyoSpjC_rvWwdeu0z
 kq68fpw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4F9E7365.2040907@att.net>
Date: Mon, 30 Apr 2012 06:11:33 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120420 Thunderbird/10.0.3
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Generic rbtree search & insert cores
X-Enigmail-Version: 1.3.5
Content-Type: multipart/mixed;
 boundary="------------090901060703010001090807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090901060703010001090807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I believe I've solved the problem of having generic search & insert cores in C.  Attached is my current working version of rbtree_ext.h.  While I've included an example in my documentation, here's a quickie:

/* Header File */
#include <linux/rbtree_ext.h>

struct house {
    struct rb_root mice;
};

struct mouse {
    struct rb_node node;
    const char*    name;
};

extern struct mouse *find_mouse(struct house *house, const char *name);
extern struct mouse *put_mouse_in_house(struct house *house,
                    struct mouse *mouse);

/* Implementation File */
#include "myheader.h"

static inline int name_cmp(const char **a, const char **b) {
    return strcmp(*a, *b);
}

static const struct rbtree_relationship rel_house_to_mouse = {
    .root_offset = offsetof(struct house, mice),
    .node_offset = offsetof(struct mouse, node),
    .key_offset  = offsetof(struct mouse, name),
    .compare     = (int(*)(const void*, const void*))name_cmp;
};

/* inline expansion occurs here and our object file doesn't bloat */
struct mouse *find_mouse(struct house *house, const char *name) {
    return rbtree_find(house, name, &rel_house_to_mouse);
}

struct mouse *put_mouse_in_house(struct house *house, struct mouse *mouse) {
    return rbtree_insert(house, mouse, 1, &rel_house_to_mouse);
}

So as long as our struct rbtree_relationship is a compile-time constant, the generated code will look pretty much (if not exactly) like that of the example code in rbtree.h.  Please let me know what you think.  I've tested this in a userspace program, but haven't fully stress tested it in kernelspace yet.

Daniel


--------------090901060703010001090807
Content-Type: text/x-chdr;
 name="rbtree_ext.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rbtree_ext.h"

/*
 * Red Black Tree Extensions
 *
 * Copyright (C) 2012  Daniel Santos <daniel.santos@pobox.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
 * USA.
 */

/*
 * Red Black Tree Extensions (brtree_ext.h) extends upon Andrea Arcangeli's
 * rbtree implementation adding the ability to define relationships between
 * containers and their contents (see struct rbtree_relationship) and feeding
 * those relationships to generic find and insert functions. By using
 * compile-time constant instances of struct rbtree_relationship and a single
 * instantiation of the static inline find & insert functions, gcc will
 * generate code that is exactly as efficient as if you had implemented your
 * own file & insert functions (as explained in rbtree.h) without the source
 * bloat and added complexity.  Further, by wrapping the static inline find &
 * insert functions in singular (non-inline) functions, type-safety can be
 * achived while preventing the bloat of inline expansion.
 *
 * For example, see rbtree_find.
 */
#ifndef _LINUX_RBTREE_EXT_H
#define _LINUX_RBTREE_EXT_H

#include <linux/rbtree.h>

/* Testing the member of a struct with __builtin_constant_p only works in gcc
 * 3.5.0 and later.
 */
#if defined(__GNUC__) && defined(__OPTIMIZE__)		\
	&& ((__GNUC__ == 3 && __GNUC_MINOR__ >= 5) || (__GNUC__ > 3))
#define CHOKE_IF_NOT_COMPILE_TIME_CONST(exp)		\
do {							\
	extern void __not_constant_linktime_error(void);\
	if (!__builtin_constant_p(exp))			\
		__not_constant_linktime_error();	\
} while (0)
#else
#define CHOKE_IF_NOT_COMPILE_TIME_CONST(exp)
#endif


#define __rbtree_toroot(o) ((struct rb_root *)((char *)(o) + rel->root_offset))
#define __rbtree_tonode(o) ((struct rb_node *)((char *)(o) + rel->node_offset))
#define __rbtree_tokey(o)  ((const void *)    ((char *)(o) + rel->key_offset))
#define __rbtree_fromnode(o) ((char *)(o) - rel->node_offset)

/**
 * struct rbtree_relationship - Defines relationship between a container and
 *                      the objects it contains.
 * @root_offset:        Offset of container's struct rb_root member.
 * @node_offset:        Offset of object's struct rb_node member.
 * @key_offset:         Offset of object's key member.
 * @compare:            Compare function for objects -- should be an inline
 *                      function in the same translation unit for proper
 *                      optimization.
 *
 * Instances of struct rbtree_relationship should be compile-time constants if
 * you want good performance.
 */
struct rbtree_relationship {
	size_t root_offset;
	size_t node_offset;
	size_t key_offset;
	int (*compare)(const void *a, const void *b);
};

/**
 * __rbtree_find() - Searches a red black tree.
 * @container:  Container to search.
 * @key:        Pointer to the key you want to find.
 * @rel:        Pointer to the (preferrably compile-time constant)
 *              relationship definition.
 *
 * See rbtree_find.
 *
 * You should use rbtree_find() instead of this function unless you need to
 * pass rel as a runtime value (this will degrade performance and bloat code
 * size somewhat).
 *
 * See rbtree_find for sample code.
 */
static inline void *__rbtree_find(void *container,
				  const void *key,
				  const struct rbtree_relationship *rel)
{
	const struct rb_node *n    = __rbtree_toroot(container)->rb_node;

	while (n) {
		const char *obj = __rbtree_fromnode(n);
		int diff        = rel->compare(__rbtree_tokey(obj), key);

		if (diff > 0)
			n = n->rb_right;
		else if (diff < 0)
			n = n->rb_left;
		else
			return (void *)obj;
	}

	return 0;
}

/**
 * rbtree_find() - Searches a red black tree.
 * @container:  Container to search.
 * @key:        Pointer to the key you want to find.
 * @rel:        Pointer to the compile-time constant relationship definition.
 *
 * On success, returns a pointer to the object (not the struct rb_node), NULL
 * otherwise. If rel is not a compile-time constant, a link-time error will
 * be generated.
 *
 * If your code calls this function from more than one place, it is highly
 * recommended that you wrap this function in a non-inline function. Not doing
 * will can result in either object code bloat or slower searches. You have
 * been advised!  Even if you are calling it from one place, wrapping it in a
 * type-specific function improves type-safety.
 *
 * Egg Sample:
 *
 * // Header File
 *
 * struct house {
 *     struct rb_root mice;
 * };
 *
 * struct mouse {
 *     struct rb_node node;
 *     struct rb_root lice;
 *     const char*    name;
 * };
 *
 * struct louse {
 *     struct rb_node node;
 *     const char*    name;
 * };
 *
 * extern struct mouse *find_mouse(struct house *house, const char *name);
 * extern struct mouse *put_mouse_in_house(struct house *house,
 *                                         struct mouse *mouse);
 *
 * extern struct louse *find_louse(struct mouse *mouse, const char *name);
 * extern struct louse *put_louse_on_mouse(struct mouse *mouse,
 *                                         struct louse *louse);
 *
 * // Implementation File
 *
 * static inline int name_cmp(const char **a, const char **b) {
 *     return strcmp(*a, *b);
 * }
 *
 * static const struct rbtree_relationship rel_house_to_mouse = {
 *     .root_offset = offsetof(struct house, mice),
 *     .node_offset = offsetof(struct mouse, node),
 *     .key_offset  = offsetof(struct mouse, name),
 *     .compare     = (int(*)(const void*, const void*))name_cmp;
 * };
 *
 * static const struct rbtree_relationship rel_mouse_to_louse = {
 *     .root_offset = offsetof(struct mouse, lice),
 *     .node_offset = offsetof(struct louse, node),
 *     .key_offset  = offsetof(struct louse, name),
 *     .compare     = (int(*)(const void*, const void*))name_cmp;
 * };
 *
 * struct mouse *find_mouse(struct house *house, const char *name) {
 *     return rbtree_find(house, name, &rel_house_to_mouse);
 * }
 *
 * struct mouse *put_mouse_in_house(struct house *house, struct mouse *mouse) {
 *     return rbtree_insert(house, mouse, 1, &rel_house_to_mouse);
 * }
 *
 * // ditto for find_louse() and put_louse_on_mouse()
 *
 */
static __always_inline void *rbtree_find(void *container,
					 const void *key,
					 const struct rbtree_relationship *rel)
{
	CHOKE_IF_NOT_COMPILE_TIME_CONST(rel->root_offset);
	return __rbtree_find(container, key, rel);
}

/**
 * __rbtree_insert() - Inserts an object into a container.
 * @container:  Pointer to the container.
 * @obj:        Pointer to the new object to insert.
 * @replace:    Rather or not to replace an existing object.
 * @rel:        Pointer to the (preferably compile-time constant) relationship
 *              definition.
 *
 * See rbtree_insert.
 *
 * You should use rbtree_insert() instead of this function unless you need to
 * pass rel as a runtime value (which will degrade performance and bloat code
 * size).
 */
static inline void *__rbtree_insert(void *container,
				    void *obj,
				    const int replace,
				    const struct rbtree_relationship *rel)
{
	struct rb_root *root   = __rbtree_toroot(container);
	struct rb_node **p     = &root->rb_node;
	struct rb_node *parent = NULL;
	struct rb_node *node   = __rbtree_tonode(obj);
	const void *key        = __rbtree_tokey(obj);

	while (*p) {
		char *thisobj = __rbtree_fromnode(*p);
		int diff      = rel->compare(__rbtree_tokey(thisobj), key);
		parent        = *p;

		if (diff > 0)
			p = &(*p)->rb_right;
		else if (diff < 0)
			p = &(*p)->rb_left;
		else {
			if (replace)
				rb_replace_node(*p, node, root);
			return thisobj;
		}
	}

	rb_link_node(node, parent, p);
	rb_insert_color(node, root);

	return 0;
}


/**
 * __rbtree_insert() - Inserts an object into a container.
 * @container:  Pointer to the container.
 * @obj:        Pointer to the new object to insert.
 * @replace:    Compile-time constant indicating rather or not the
 *              implementation should replace an existing object.
 * @rel:        Pointer to the compile-time constant relationship definition.
 *
 * If an object with the same key already exists and replace is non-zero,
 * then it is replaced with obj; if replace is zero, then no change is made.
 * In either case, a pointer to the existing object is returned. Note that
 * return values are pointers to the objects themselves, not to the struct
 * rb_node.
 *
 * If no object with the same key exists, then obj is inserted and NULL is
 * returned.
 *
 * If either rel or replace are not a compile-time constants, a link-time
 * error will be generated.
 *
 * See rbtree_find for example.
 */
static __always_inline void *rbtree_insert(void *container,
					   void *obj,
					   const int replace,
					   const struct rbtree_relationship *rel)
{
	CHOKE_IF_NOT_COMPILE_TIME_CONST(rel->root_offset);
	CHOKE_IF_NOT_COMPILE_TIME_CONST(replace);
	return __rbtree_insert(container, obj, replace, rel);
}

/**
 * __rbtree_replace() - minor wrapper to rb_replace_node
 */
static inline void __rbtree_replace(void *container,
				    void *victim,
				    void *newobj,
				    const struct rbtree_relationship *rel)
{
	rb_replace_node(__rbtree_tonode(victim),
			__rbtree_tonode(newobj),
			__rbtree_toroot(container));
}

/**
 * rbtree_replace() - minor wrapper to rb_replace_node
 */
static __always_inline void rbtree_replace(void *container,
					   void *victim,
					   void *newobj,
					   const struct rbtree_relationship *rel)
{
	CHOKE_IF_NOT_COMPILE_TIME_CONST(rel->root_offset);
	__rbtree_replace(container, victim, newobj, rel);
}

#endif /* _LINUX_RBTREE_EXT_H */

--------------090901060703010001090807--
