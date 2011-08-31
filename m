Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab1HaWg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:36:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45747 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1HaWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:36:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110827134038.GH3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
 <20110818143319.GC10441@somewhere> <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com>
 <20110824175431.GA26417@somewhere.redhat.com> <CALdu-PAiRgjFaERETAZVH=+Ky-0ekjBWn6aDK5Hzam1AQ7sC4Q@mail.gmail.com>
 <20110827134038.GH3298@somewhere>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 31 Aug 2011 15:36:05 -0700
X-Google-Sender-Auth: JgZX_CB9wh8xqkEfCX7snC6d7VM
Message-ID: <CALdu-PD0uamdriTGEd0qbxbrWZt6ZBDWk-CgsDDE-SWxctXkkA@mail.gmail.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem? (was
 Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 6:40 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> Whatever we do, we need that lock. So we can pick your
> solution that references cgroups that belong to multi-bindable
> subsystems for a given task in css_set, or we can have tsk->cgroups->subsys[]
> a variable size array that references 1 * singletons and N * multi
> bindable subsystems, N beeing the number of hierarchies that use
> a given subsystem.

I think that the two approaches give access to the same amount of
information, and would need to be constructed and used in
approximately the same way.

I think that adding the hierarchy->cgroup mapping as a variable-sized
array is simpler conceptually than making the existing fixed-size
subsys array be variable sized and shifting whenever a hierarchy is
added/removed.

But I think the first approach to try would be:

- make task_cgroup_from_root callable with either the task being
locked or cgroup_mutex being held
- expose this in some way outside of the cgroups framework - maybe a
function that returns an array of cgroups for a task, one for each
hierarchy.

This wouldn't involve adding any extra data structures, and we could
later make css_set cache more information if it turned out that it
needed better performance.

Paul
