Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1BDQTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:19:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61670 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1BDQTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D5LODvHBvQiNqatq0zwU8lh34gxsfv4NkYzs8MpvKT/Dzdbl1FkcZTqUM0Gp6HkRgP
         u+b8farhacN6yoY0WzuEraT7XXWQTZ2+HFI7Ve33y+HyJ8glyXcnJzjNJ4DYV8Nnb64V
         z33B3RnTClWY+K0s+lmWNcYXICLFi2DxLsIkg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3kKhWRzM7S_f18YJ=jx1P7bN9zVo9yGC7zwN_@mail.gmail.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com> <AANLkTi=3kKhWRzM7S_f18YJ=jx1P7bN9zVo9yGC7zwN_@mail.gmail.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Fri, 4 Feb 2011 17:59:24 +0200
Message-ID: <AANLkTik=a3NmibvYM6NxvqCiSiaE0oUFNtRaqn4+g_+D@mail.gmail.com>
Subject: Re: [PATCH 0/5] net: sysctl: share ipv4/ipv6 sysctl tables
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 12:49 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> Finally share the leaf sysctl tables for ipv4/ipv6:
>>
>>  [PATCH 4/5] ipv4: share sysctl net/ipv4/conf/DEVNAME/ tables
>>  [PATCH 5/5] ipv6: share sysctl net/ipv6/conf/DEVNAME/ tables
>
> Meh.
>
> First you remove ->parent, then heroically pass "struct file *"
> to sysctl handlers which duplicates all information already passed
> and brings dcache into picture.
>
> Binary sysctl rewrite confused you into thinking that d_name.name
> is the way, but it isn't.
> For binary sysctl(2) you wouldn't get d_name.name.


Are you really sure?

I ran this code on a machine with and without these patches. It seems
to work fine.

It reads the value from /proc/sys/net/ipv4/conf/default/tag and writes 42 back.

I'm not sure what I have to do to pass the name of a device (e.g.
"eth0") instead of "default" but at least "default" and "all" work and
have valid dentries.


#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/sysctl.h>


int main(void)
{
	struct __sysctl_args args;
	int oldtag, newtag;
	size_t oldtaglen, newtaglen;

	int name[] = { CTL_NET, NET_IPV4, NET_IPV4_CONF,
NET_PROTO_CONF_DEFAULT, NET_IPV4_CONF_TAG };

	memset(&args, 0, sizeof(struct __sysctl_args));
	args.name = name;
	args.nlen = sizeof(name)/sizeof(name[0]);

	oldtag = -1;
	oldtaglen = sizeof(oldtag);
	args.oldval = &oldtag;
	args.oldlenp = &oldtaglen;

	newtag = 42;
	newtaglen = sizeof(newtag);
	args.newval = &newtag;
	args.newlen = newtaglen;

	if (syscall(SYS__sysctl, &args) == -1) {
		perror("_sysctl");
		exit(EXIT_FAILURE);
	}
	printf("Old tag was %d, new tag is %d\n", oldtag, newtag);
	exit(EXIT_SUCCESS);
}


-- 
 .
..: Lucian
