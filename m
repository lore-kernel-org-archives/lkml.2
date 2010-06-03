Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab0FCEoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:44:55 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:44529 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0FCEow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:44:52 -0400
Date: Thu, 3 Jun 2010 00:44:16 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ben Blum <bblum@andrew.cmu.edu>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100603044416.GB21006@ghc02.ghc.andrew.cmu.edu>
References: <20100531180446.GA16249@redhat.com>
 <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
 <20100602140659.GA5324@redhat.com>
 <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
 <20100602202048.GB28663@redhat.com>
 <AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
 <20100602205855.GA30039@redhat.com>
 <AANLkTimfHlapl7mbRyAazWW5q5Wzs23n6i9wIhVtSv6r@mail.gmail.com>
 <20100602213832.GB31949@redhat.com>
 <AANLkTimsusetA9B95-LvKsDdAB_PegYH7Zljyi4Doe_q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimsusetA9B95-LvKsDdAB_PegYH7Zljyi4Doe_q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.6.3.42715
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 03:03:49PM -0700, Paul Menage wrote:
> On Wed, Jun 2, 2010 at 2:38 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > cgroup_attach_task() does, and this time PF_EXITING is understandable.
> >
> 
> Oh, OK, I was talking about the one in cgroup_attach_task(), which is
> called by attach_task_by_pid(), and assumed that you were referring to
> the same one. I'd forgotten about the pre-check in
> attach_task_by_pid(). Yes, that one could probably be removed without
> affecting any final outcomes.
> 
> Paul

Yes, I agree. The check should be moved into cgroup_attach_task before
the ss->can_attach calls, so the "optimization" stays in the case where
it's wanted.

And the use of __task_cred after the exiting check seems safe too if the
check is gone - from cred.h: "The caller must make sure task doesn't go
away, either by holding a ref on task or by holding tasklist_lock to
prevent it from being unlinked." So that means it'd be safe to take a
reference, task sets exiting and does everything before unhashing, then
access the cred pointer; since we hold tasklist lock it's the same case.

-- Ben
