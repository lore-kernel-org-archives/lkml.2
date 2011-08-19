Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1HSMpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:45:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44573 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HSMpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110819122503.GA8411@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de>
 <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
 <20110818184857.GA12094@redhat.com> <1313717521.991.4.camel@mop> <20110819122503.GA8411@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 19 Aug 2011 14:44:46 +0200
Message-ID: <CAPXgP11KC2fTWBVYo6CBXe924YAyTGhx9=UTBDf4cP5Acuo0NA@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 14:25, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/19, Kay Sievers wrote:
>> +             /* find the first ancestor marked as child_subreaper */
>> +             for (reaper = father->real_parent;
>> +                  reaper != reaper->real_parent;
>
> This looks mysterious. This relies on the fact that INIT_TASK(tsk)
> sets .real_parent = tsk. "reaper != &init_task" looks much more clean.
>
> But. Now that you check ->has_child_subreaper before the lookup,
> this problem should go away? I mean, if ->has_child_subreaper == T
> then some of our parents is the userspace task. Even if it was
> spawned by kthread and then exited, we can't miss ->child_reaper
> in the parents chain.

That's right. We only ever look at 'flagged' processes now, and no
other than a userspace process can ever be tagged. We can just walk up
to  ->child_reaper.

> Or I missed something?

I think that's right. I'll test it.

>> +             case PR_SET_CHILD_SUBREAPER:
>> +                     me->signal->is_child_subreaper = !!arg2;
>> +                     me->signal->has_child_subreaper = true;
>
> Hmm. This looks wrong... why do we set ->has_child_subreaper?

That's the flag we pass down to our childs, hence we need to set it here.

Kay
