Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1EFRis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1EFRir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:38:47 -0400
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Eric Paris <eparis@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 06 May 2011 12:30:33 -0400
In-Reply-To: <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
References: <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <BANLkTimPFHwJfqXHShnOt7mBp84NQQNWDw@mail.gmail.com>
	 <20110504175229.GB1804@nowhere>
	 <1304533382.25414.2447.camel@gandalf.stny.rr.com>
	 <20110504183052.GD1804@nowhere>
	 <1304534785.25414.2452.camel@gandalf.stny.rr.com>
	 <BANLkTin2ZS8DCLGZXxV7EN+S-aNRK=B8Sw@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-HGmfvKg8mu7GMCBeYrG+"
Message-ID: <1304699437.10692.78.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HGmfvKg8mu7GMCBeYrG+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2011-05-05 at 02:21 -0700, Will Drewry wrote:
> On Wed, May 4, 2011 at 11:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> In particular, if the userspace code wants to stage some filters and
> apply them all at once, when ready, I'm not sure that it makes sense
> to me to put that complexity in the kernel itself.  For instance,
> Eric's second sample showed a call that took an array of ints and
> coalesced them into "fd == %d || ...".  That simple example shows that
> we could easily get by with a pretty minimal kernel-supported
> interface as long as the richer behavior could live userspace side --
> even if just in a simple helper library.  It'd be pretty easy to
> implement a userspace library that exposed add_filter(syscall_nr,
> filter) and apply_filters() such that it could manage building the
> final filter string for a given syscall and pushing it to prctl on
> apply.

Had a few minutes this morning so I started writing something that looks
sorta like a userspace library.  It dosn't have unset yet but I don't
think it'll be that hard for me to implement.  You can build some pretty
complex filters easily.  Not sure when I'll get to work on it more, but
it at least shows the idea of doing the complex work in a library and
keeping a simple kernel interface....  Any thoughts?

-Eric

--=-HGmfvKg8mu7GMCBeYrG+
Content-Disposition: attachment; filename="libseccomp.c"
Content-Type: text/x-csrc; name="libseccomp.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "libseccomp.h"

/*
 * () around the string is 2
 * '\0' at the end is 1
 * Total extra space needed is 3
 */
#define SECCOMP_STRING_BYTES	3

typedef struct seccomp_filter {
#define SECCOMP_FILTER_TYPE_UNSET	0
#define SECCOMP_FILTER_TYPE_NODE	1
#define SECCOMP_FILTER_TYPE_LEAF	2
	char type;
	struct seccomp_filter *parent;
	struct seccomp_filter *left;
	struct seccomp_filter *right;
#define SECCOMP_FILTER_OP_UNSET		0
#define SECCOMP_FILTER_OP_AND		" && "
#define SECCOMP_FILTER_OP_OR		" || "
#define SECCOMP_FILTER_OP_EQUAL		" == "
#define SECCOMP_FILTER_OP_NOT_EQUAL	" != "
#define SECCOMP_FILTER_OP_LESS		" < "
#define SECCOMP_FILTER_OP_LESS_EQUAL	" <= "
#define SECCOMP_FILTER_OP_GREATER	" > "
#define SECCOMP_FILTER_OP_GREATER_EQUAL	" >= "
#define SECCOMP_FILTER_OP_ONE		" 1 "
#define SECCOMP_FILTER_OP_ZERO		" 0 "	
	const char *operation;
	char *arg;
	char *value;
} seccomp_filter_t;

char *seccomp_filter_to_string(seccomp_filter_t *sf)
{
	size_t newlen, len;
	char *left = NULL;
	char *right = NULL;
	char *out;
	char *p;

	if (sf->type == SECCOMP_FILTER_TYPE_NODE) {
		left = seccomp_filter_to_string(sf->left);
		if (!left)
			return NULL;
		right = seccomp_filter_to_string(sf->right);
		if (!right) {
			free(left);
			return NULL;
		}

		if (strcmp(sf->operation, SECCOMP_FILTER_OP_AND) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_OR))
			assert(0);
	} else if (sf->type == SECCOMP_FILTER_TYPE_LEAF) {
		if (sf->arg) {
			left = strdup(sf->arg);
			if (!left)
				return NULL;
		}
		if (sf->value) {
			right = strdup(sf->value);
			if (!right) {
				free(left);
				return NULL;
			}
		}

		if (strcmp(sf->operation, SECCOMP_FILTER_OP_EQUAL) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_NOT_EQUAL) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_LESS) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_LESS_EQUAL) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_GREATER) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_GREATER_EQUAL) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_ONE) &&
		    strcmp(sf->operation, SECCOMP_FILTER_OP_ZERO))
			assert(0);
	} else {
		assert(0);
	}

	newlen = 0;
	if (left)
		newlen += strlen(left);
	newlen += strlen(sf->operation);
	if (right)
		newlen += strlen(right);
	newlen += SECCOMP_STRING_BYTES;

	out = malloc(newlen);
	if (!out) {
		free(left);
		free(right);
		return NULL;
	}

	p = out;

	len = sprintf(p, "(");
	p += len;
	if (left) {
		len = sprintf(p, "%s", left);
		p += len;
	}
	len = sprintf(p, "%s", sf->operation);
	p += len;
	if (right) {
		len = sprintf(p, "%s", right);
		p += len;
	}
	len = sprintf(p, ")");
	p += len;

	assert((size_t)(p-out) == (newlen - 1));

	free(left);
	free(right);
	return out;
}

seccomp_filter_t *__seccomp_filter_alloc(void)
{
	seccomp_filter_t *sf;

	sf = malloc(sizeof(*sf));
	if (!sf)
		return NULL;

	memset(sf, 0, sizeof(*sf));
	return sf;
}

void seccomp_filter_free(seccomp_filter_t *sf)
{
	if (sf->type == SECCOMP_FILTER_TYPE_NODE) {
		seccomp_filter_free(sf->left);
		seccomp_filter_free(sf->right);
	} else if (sf->type == SECCOMP_FILTER_TYPE_LEAF) {
		free(sf->arg);
		free(sf->value);
	}
	free(sf);
}

seccomp_filter_t *seccomp_and_filters(seccomp_filter_t *left, seccomp_filter_t *right)
{
	seccomp_filter_t *sf;

	sf = __seccomp_filter_alloc();
	if (!sf)
		return NULL;

	left->parent = sf;
	right->parent = sf;

	sf->type = SECCOMP_FILTER_TYPE_NODE;
	sf->operation = SECCOMP_FILTER_OP_AND;
	sf->left = left;
	sf->right = right;

	return sf;
}

seccomp_filter_t *seccomp_or_filters(seccomp_filter_t *left, seccomp_filter_t *right)
{
	seccomp_filter_t *sf;

	sf = __seccomp_filter_alloc();
	if (!sf)
		return NULL;

	left->parent = sf;
	right->parent = sf;

	sf->type = SECCOMP_FILTER_TYPE_NODE;
	sf->operation = SECCOMP_FILTER_OP_OR;
	sf->left = left;
	sf->right = right;

	return sf;
}

int __seccomp_filter_same(seccomp_filter_t *sf1, seccomp_filter_t *sf2)
{
	if (sf1->type != sf2->type)
		return 0;
	if (strcmp(sf1->operation, sf2->operation))
		return 0;
	if (sf1->type == SECCOMP_FILTER_TYPE_NODE) {
		if (!__seccomp_filter_same(sf1->left, sf2->left))
			return 0;
		if (!__seccomp_filter_same(sf1->right, sf2->right))
			return 0;
	} else if (sf1->type == SECCOMP_FILTER_TYPE_LEAF) {
		if (sf1->arg && !sf2->arg)
			return 0;
		if (!sf1->arg && sf2->arg)
			return 0;
		if (sf1->arg && strcmp(sf1->arg, sf2->arg))
			return 0;
		if (sf1->value && !sf2->value)
			return 0;
		if (!sf1->value && sf2->value)
			return 0;
		if (sf1->value && strcmp(sf1->value, sf2->value))
			return 0;
	} else {
		assert(0);
	}
	return 1;
}

seccomp_filter_t *__seccomp_arg_value(char *operation, char *arg, char *value)
{
	seccomp_filter_t *sf;

	sf = __seccomp_filter_alloc();
	if (!sf)
		return NULL;

	sf->type = SECCOMP_FILTER_TYPE_LEAF;
	sf->operation = operation;
	if (arg) {
		sf->arg = strdup(arg);
		if (!sf->arg)
			goto err;
	}

	if (value) {
		sf->value = strdup(value);
		if (!sf->value)
			goto err;
	}

	return sf;
err:
	free(sf->arg);
	free(sf->value);
	free(sf);
	return NULL;
}

seccomp_filter_t *seccomp_one(void)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_ONE, NULL, NULL);
}

seccomp_filter_t *seccomp_zero(void)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_ZERO, NULL, NULL);
}

seccomp_filter_t *seccomp_equal_arg_value(char *arg, char *value)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_EQUAL, arg, value);
}

seccomp_filter_t *seccomp_not_equal_arg_value(char *arg, char *value)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_NOT_EQUAL, arg, value);
}

seccomp_filter_t *seccomp_less_arg_value(char *arg, char *value)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_LESS, arg, value);
}

seccomp_filter_t *seccomp_less_equal_arg_value(char *arg, char *value)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_LESS_EQUAL, arg, value);
}

seccomp_filter_t *seccomp_greater_arg_value(char *arg, char *value)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_GREATER, arg, value);
}

seccomp_filter_t *seccomp_greater_equal_arg_value(char *arg, char *value)
{
	return __seccomp_arg_value(SECCOMP_FILTER_OP_GREATER_EQUAL, arg, value);
}

int seccomp_filter_unset(seccomp_filter_t *tree __attribute__((unused)),
			 seccomp_filter_t *subset __attribute__((unused)))
{
/*
	seccompt_filter_t *sf;

	if (__seccomp_filter_same(tree, subset)) {
	} else if (tree->type == SECCOMP_FILTER_TYPE_NODE) {
		if (!seccomp_filter_unset(tree->left, subset))
			return 0;
		if (!seccomp_filter_unset(tree->right, subset))
			return 0;
	} else {
		return -EINVAL;
	}
 */
	return 0;
}

--=-HGmfvKg8mu7GMCBeYrG+
Content-Disposition: attachment; filename="libseccomp.h"
Content-Type: text/x-chdr; name="libseccomp.h"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

typedef struct seccomp_filter seccomp_filter_t;

char *seccomp_filter_to_string(seccomp_filter_t *sf);
seccomp_filter_t *seccomp_and_filters(seccomp_filter_t *left, seccomp_filter_t *right);
seccomp_filter_t *seccomp_or_filters(seccomp_filter_t *left, seccomp_filter_t *right);
seccomp_filter_t *seccomp_equal_arg_value(char *arg, char *value);
seccomp_filter_t *seccomp_not_equal_arg_value(char *arg, char *value);
seccomp_filter_t *seccomp_less_arg_value(char *arg, char *value);
seccomp_filter_t *seccomp_less_equal_arg_value(char *arg, char *value);
seccomp_filter_t *seccomp_greater_arg_value(char *arg, char *value);
seccomp_filter_t *seccomp_greater_equal_arg_value(char *arg, char *value);
seccomp_filter_t *seccomp_one(void);
seccomp_filter_t *seccomp_zero(void);
void seccomp_filter_free(seccomp_filter_t *sf);

--=-HGmfvKg8mu7GMCBeYrG+
Content-Disposition: attachment; filename="Makefile"
Content-Type: text/x-makefile; name="Makefile"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

all: libseccomp.o test

libseccomp.o: libseccomp.c libseccomp.h Makefile
	gcc -o libseccomp.o -Wall -Wextra -Werror -W -g -c libseccomp.c

test: test.c libseccomp.h libseccomp.o Makefile
	gcc -o test -Wall -Wextra -Werror -W -g test.c libseccomp.o

clean:
	rm -f test libseccomp.o

--=-HGmfvKg8mu7GMCBeYrG+
Content-Disposition: attachment; filename="test.c"
Content-Type: text/x-csrc; name="test.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <stdio.h>

#include "libseccomp.h"

int main(void)
{
	seccomp_filter_t *left, *right, *sf1, *sf2, *sf;
	char *string;

	left = seccomp_equal_arg_value("a0", "1");
	if (!left)
		return 1;

	right = seccomp_not_equal_arg_value("a0", "0");
	if (!right)
		return 1;

	sf1 = seccomp_and_filters(left, right);
	if (!sf1)
		return 1;

	left = seccomp_greater_arg_value("a1", "100");
	if (!left)
		return 1;

	right = seccomp_less_equal_arg_value("a1", "1000");
	if (!right)
		return 1;

	sf2 = seccomp_or_filters(left, right);
	if (!sf2)
		return 1;

	sf = seccomp_and_filters(sf1, sf2);
	if (!sf)
		return 1;

	right = seccomp_one();
	if (!right)
		return 1;

	sf = seccomp_and_filters(sf, right);
	if (!sf)
		return 1;

	string = seccomp_filter_to_string(sf);
	if (!string)
		return 1;

	printf("%s\n", string);
	return 0;
}

--=-HGmfvKg8mu7GMCBeYrG+--

