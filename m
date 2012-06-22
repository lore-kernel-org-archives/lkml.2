Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448Ab2FVHGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:06:04 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:50216 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761418Ab2FVHGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <1339549862-653-2-git-send-email-john.stultz@linaro.org>
References: <1339549862-653-1-git-send-email-john.stultz@linaro.org>
	<1339549862-653-2-git-send-email-john.stultz@linaro.org>
Date: Fri, 22 Jun 2012 00:06:00 -0700
Message-ID: <CANN689EUC26UjmGSAhsmZD5iPjmzTPPgGsZ9ZyPfy0RHFBp06g@mail.gmail.com>
Subject: Re: [PATCH 1/6] [RFC] Interval tree implementation
From: Michel Lespinasse <walken@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 6:10 PM, John Stultz <john.stultz@linaro.org> wrote:
> After Andrew suggested something like his mumbletree idea
> to better store a list of intervals, I worked on a few different
> approaches, and this is what I've finally managed to get working.
>
> The idea of storing intervals in a tree is nice, but has a number
> of complications. When adding an interval, its possible that a
> large interval will consume and merge a number of smaller intervals.
> When removing a interval, its possible you may end up splitting an
> existing interval, causing one interval to become two. This makes it
> very difficult to provide generic list_head like behavior, as
> the parent structures would need to be duplicated and removed,
> and that has lots of memory ownership issues.
>
> So, this is a much simplified and more list_head like
> implementation. You can add a node to a tree, or remove a node
> to a tree, but the generic implementation doesn't do the
> merging or splitting for you. But it does provide helpers to
> find overlapping and adjacent intervals.
>
> Andrew also really wanted this interval-tree implementation to be
> resuable so we don't duplicate the file locking logic. I'm not
> totally convinced that the requirements between the volatile
> intervals and file locking are really equivelent, but this reduced
> impelementation may make it possible.

Well, we already have several implementations of interval trees:

* lib/prio_tree.c seems to do what you want. It's often used with
VMAs, but there is also a 'raw' node structure, as used in
mm/kmemleak.c, which supports all the operations you are proposing.

* lib/rb_tree.c has some support for the "augmented tree" structure,
with which you can implement interval trees as is done in
arch/x86/mm/pat_rbtree.c

I don't think it makes sense to have two implementations already, and
I am looking into possibly collapsing these into one. Please don't add
a third one :)


Also, the name "interval tree" typically implies a data structure that
is capable of representing overlapping intervals. Since your
implementation does not support that (it requires its callers to make
sure the intervals are non-overlapping), I think calling it "interval
tree" could cause confusion.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
