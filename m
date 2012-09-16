Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2IPLaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 07:30:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33628 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2IPLaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 07:30:08 -0400
Message-ID: <5055B852.4010906@gmail.com>
Date: Sun, 16 Sep 2012 13:30:26 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Matthias Diener <matthias.diener@mdiener.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] hashtable: introduce a small and naive hashtable
References: <CAKBUcnA4b8HaV3-20C8QXXgFXW4ZDfOc6SvYCFsA3mtdyEd89Q@mail.gmail.com>
In-Reply-To: <CAKBUcnA4b8HaV3-20C8QXXgFXW4ZDfOc6SvYCFsA3mtdyEd89Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050805040305020403040309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050805040305020403040309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/16/2012 01:08 AM, Matthias Diener wrote:
> Sasha Levin (levinsasha928 <at> gmail.com) wrote:
>> On Sat, Sep 15, 2012 at 5:14 PM, Mathieu Desnoyers
>> <mathieu.desnoyers <at> efficios.com> wrote:
>>> * Sasha Levin (levinsasha928 <at> gmail.com) wrote:
> [...]
>>>> +#define hash_init(hashtable)                                                 \
>>>> +({                                                                           \
>>>> +     int __i;                                                                \
>>>> +                                                                             \
>>>> +     for (__i = 0; __i < HASH_BITS(hashtable); __i++)                        \
>>>
>>> I think this fails to initialize the whole table. You'd need
>>>
>>>   HASH_BITS -> HASH_SIZE
>>
>> Right.
>>
>> Unfortunately it's pretty hard catching something like this :/
>>
>>> Which brings the following question: how did you test this code ? It
>>> would be nice to have a small test module along with this patchset that
>>> stress-tests this simple hash table in various configurations (on stack,
>>> in data, etc).
>>
>> I do two things:
>>
>> - A small userspace test (since this header works just fine from
>> userspace as well).
> 
> 
> It would be interesting to run some experiments with this hashtable in
> userspace.
> Could you post the test code here?

Sure, I've attached the test code. There are 2 things to remember it:

 1. The code looks like crap :) I've never intended it to be seen by others.
 2. It should be used in the context of "sanitized" kernel headers so it could
be included directly. I usually work in the directory of lkvm, and compile this
code using:

	gcc -Iinclude/ -I../../include/ -O0 -ggdb  hashtest.c



--------------050805040305020403040309
Content-Type: text/x-csrc;
 name="hashtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hashtest.c"

#define BITS_PER_LONG 64
#include <linux/kernel.h>
#include <linux/hashtable.h>
#include <kvm/util.h>
#include <linux/log2.h>
#include <assert.h>

struct my_data {
	int x;
	struct hlist_node node;
};

static DECLARE_HASHTABLE(test, 10);
static struct my_data *values[1000000];

struct my_data *get_data(int v)
{
	struct my_data *p;
	struct hlist_node *n;

	hash_for_each_possible(test, p, n, node, v)
		if (p->x == v)
			return p;

	return NULL;
}

bool verify(int i)
{
	if (values[i] == NULL && get_data(i))
		printf("No data, but found at %p (%d)\n", get_data(i), i);
	if (values[i])
		return get_data(i) ? true : false;
	else
		return get_data(i) ? false : true;
}

int main(void)
{
	int i;

	hash_init(test);

	printf("Empty? %d\n", hash_empty(test));

	while (1) {
	for (i = 0; i < ARRAY_SIZE(values); i++) {
		int r = rand() % 3;

		if (i % 10000 == 0) {
			printf("\r%d ...", i);
			fflush(stdout);
		}

		switch (r) {
		case 0:
			assert(verify(i));
			if (values[i])
				break;
			values[i] = malloc(sizeof(values[i]));
			values[i]->x = i;
			hash_add(test, &values[i]->node, i);
			assert(verify(i));
			break;
		case 1:
			assert(verify(i));

			break;
		case 2:
			assert(verify(i));
			if (values[i]) {
				hash_del(&values[i]->node);
				free(values[i]);
				values[i] = NULL;
			}
			assert(verify(i));
			break;
		}
	}
	}
	return 0;
}

--------------050805040305020403040309--
