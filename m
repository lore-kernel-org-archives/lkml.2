Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab1GKUmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:42:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab1GKUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:42:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=ed9dYfziWxRymNDiWfEu+1p/fT6Omd+XTva44Z9E+S6LhextR5RVXImxa6+L9DJJJ
	mGwF4qwl2CXavxsFONeHg==
MIME-Version: 1.0
In-Reply-To: <1310393706-321-3-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-3-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 11 Jul 2011 13:41:31 -0700
Message-ID: <CAJniumXEPUkRpLdfnu3g-NPBH_mEKYmov1P6+6m3+SXh9sZCvA@mail.gmail.com>
Subject: Re: [PATCH 2/7] cgroups: New resource counter inheritance API
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Provide an API to inherit a counter value from a parent.
> This can be useful to implement cgroup.clone_children on
> a resource counter.
>
> Still the resources of the children are limited by those
> of the parent, so this is only to provide a default setting
> behaviour when clone_children is set.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Can't this be just:

void res_counter_inherit(struct res_counter *counter, int member) {
  struct res_counter *parent;
  parent = counter->parent;
  if (parent)
    res_counter_write_u64(counter, member,
res_counter_read_u64(parent, member));
}

This is just used at cgroup creation time, right? So the performance
impact of an extra cli/sti shouldn't matter.

Also, looking at the code res_counter_read_u64() appears to not do any
locking. I don't recall why I added it like that, but it probably
ought to do at least an atomic64_read().

Paul
