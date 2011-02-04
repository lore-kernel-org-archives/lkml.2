Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BDKtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:49:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33445 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1BDKtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:49:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RWF0tXDXXnsfGA5z51shL1hMUyG+n4lN4zVoxLLHhUkTBD9DzznG09oPQXiJo4ui/8
         Vyaq6q5wfh8uqx3DOI/BF1CSkcevDE17MolRHmzV1Kd7aqlIFOx34t7UH1oeBt+ZPuc6
         4nEARme/cGbpJKgAZF0mnvvksLR/KpzQvr2qI=
MIME-Version: 1.0
In-Reply-To: <cover.1296793770.git.lucian.grijincu@gmail.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com>
Date: Fri, 4 Feb 2011 12:49:41 +0200
Message-ID: <AANLkTi=3kKhWRzM7S_f18YJ=jx1P7bN9zVo9yGC7zwN_@mail.gmail.com>
Subject: Re: [PATCH 0/5] net: sysctl: share ipv4/ipv6 sysctl tables
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 6:37 AM, Lucian Adrian Grijincu
<lucian.grijincu@gmail.com> wrote:
> Each network device gets the same 25/24 sysctl entries for ipv4/ipv6
> in /proc/sys/net/ipv4/conf/DEVNAME and /proc/sys/net/ipv6/conf/DEVNAME
>
> Unfortunately, space is wasted holding very much similar data.
> Fortunately, with some tricks these entries can be shared between all
> network devices.
>
>
> The single entry in 'struct ctl_table' that was modified at runtime
> for leaf ctl_table nodes and prevented sharing was 'parent'. This
> field was first introduces for selinux and then was used to implement
> sysctl_check_table. Selinux recently removed the need for this field:
> * http://thread.gmane.org/gmane.linux.kernel.lsm/12623
> * LKML-Reference: 1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com
>
>
> Remove the need for 'parent' in sysctl_check_table and remove the
> 'parent' field:
>
>  [PATCH 1/5] sysctl: faster reimplementation of sysctl_check_table
>  [PATCH 2/5] sysctl: remove useless ctl_table->parent field
>
>
> Pave the way for sharing of ipv4/6 tables: allow data to be stored in
> the nodes above the leafs that will be shared:
>
>  [PATCH 3/5] sysctl: write ctl_table->extra2 to entries created from ctl_path
>
>
> Finally share the leaf sysctl tables for ipv4/ipv6:
>
>  [PATCH 4/5] ipv4: share sysctl net/ipv4/conf/DEVNAME/ tables
>  [PATCH 5/5] ipv6: share sysctl net/ipv6/conf/DEVNAME/ tables

Meh.

First you remove ->parent, then heroically pass "struct file *"
to sysctl handlers which duplicates all information already passed
and brings dcache into picture.

Binary sysctl rewrite confused you into thinking that d_name.name
is the way, but it isn't.
For binary sysctl(2) you wouldn't get d_name.name.
