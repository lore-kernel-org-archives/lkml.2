Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1HSNQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab1HSNQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:16:36 -0400
Date: Fri, 19 Aug 2011 15:13:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110819131339.GB8411@redhat.com>
References: <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com> <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de> <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop> <20110818184857.GA12094@redhat.com> <1313717521.991.4.camel@mop> <20110819122503.GA8411@redhat.com> <CAPXgP11KC2fTWBVYo6CBXe924YAyTGhx9=UTBDf4cP5Acuo0NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP11KC2fTWBVYo6CBXe924YAyTGhx9=UTBDf4cP5Acuo0NA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Kay Sievers wrote:
>
> On Fri, Aug 19, 2011 at 14:25, Oleg Nesterov <oleg@redhat.com> wrote:
>
> >> +             case PR_SET_CHILD_SUBREAPER:
> >> +                     me->signal->is_child_subreaper = !!arg2;
> >> +                     me->signal->has_child_subreaper = true;
> >
> > Hmm. This looks wrong... why do we set ->has_child_subreaper?
>
> That's the flag we pass down to our childs, hence we need to set it here.

Aha, I see. I've misread copy_signal(), it copies ->has_child_subreaper,
_not_ ->is_child_subreaper (as I wrongly thought) from parent. And I was
going to blame this logic in the next email, I already started to write it ;)

But this has other (OK, minor) problems too, afaics. First of all, this
->has_child_subreaper = T is not right when the caller exits. We should
not look for ->is_child_subreaper parent, our children should to find us.

Right?

And. afaics this makes the semantics of prctl(REAPER) a bit unclear...
Suppose a task P does

	C1 = fork();

	prctl(REAPER);

	C2 = fork();

In this case it "owns" the children of C2, but not C1. This is fine, and
perhaps this is even better.

But what if P->parent did prctl(REAPER) too? Then P becomes the sub-reaper
for the tasks which were forked before prctl().

In short, in general the caller of prctl(REAPER) doesn't know how this
can affect the forks in the past.

Again, again, I am not arguing. Just I think we should discuss everything
if we are going to add the new feature.



Finally. I am not sure this is really better, but it seems we can
can ->has_child_subreape "more correct" with the same effect.

	- prctl(PR_SET_CHILD_SUBREAPER):

		me->is_child_subreaper = !!arg2;
		// ->has_child_subreaper is not set

	- copy_signal():

		me->has_child_subreaper =
			parent->has_child_subreaper ||
			parent->is_child_subreaper;

Oleg.

