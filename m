Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2HPSD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:03:27 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:53322 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2HPSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:03:25 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgROAJE1LVBV5qoUPGdsb2JhbABFhRiFI69xGQEBAQEeGQ0ngiABAQUnExwTAQ8QCAMYLhQlChoTiBG7CBSKdoV3YAOVToVsjQg
X-IronPort-AV: E=Sophos;i="4.77,780,1336341600"; 
   d="scan'208";a="98427134"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 16 Aug 2012 20:07:32 +0200
To: Ping Cheng <pinglinux@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/19] Input: MT - Handle frame synchronization in core
Message-ID: <20120816180732.GA451@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-10-git-send-email-rydberg@euromail.se>
 <CAF8JNhLBO72-Rpm7dFWfYLPvbhDZZsm2yOy_7sREnNhTWqZ04w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8JNhLBO72-Rpm7dFWfYLPvbhDZZsm2yOy_7sREnNhTWqZ04w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:28:17PM -0700, Ping Cheng wrote:
> On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Collect common frame synchronization tasks in a new function,
> > input_mt_sync_frame(). Depending on the flags set, it drops
> > unseen contacts and performs pointer emulation.
> >
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> I went through the patchset except those for bcm5974. Since there are
> changes that affect other drivers, do you plan to update the affected
> drivers as well?

I am not sure what you mean here? There is a patch with in-kernel api
changes, which also changes all drivers using the api. Some of those
drivers will benefit from further changes, but that is a different
story.

> > +void input_mt_sync_frame(struct input_dev *dev)
> > +{
> > +       struct input_mt *mt = dev->mt;
> > +       struct input_mt_slot *s;
> > +
> > +       if (!mt)
> > +               return;
> > +
> > +       if (mt->flags & INPUT_MT_DROP_UNUSED) {
> > +               for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
> > +                       if (s->frame == mt->frame)
> > +                               continue;
> > +                       input_mt_slot(dev, s - mt->slots);
> > +                       input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
> > +               }
> > +       }
> > +
> > +       if (mt->flags & INPUT_MT_POINTER)
> > +               input_mt_report_pointer_emulation(dev, true);
> > +
> > +       if (mt->flags & INPUT_MT_DIRECT)
> > +               input_mt_report_pointer_emulation(dev, false);
> > +
> > +       mt->frame++;
> 
> Where do we reset this frame counter?

Why would we reset it? It is used in the core to keep track of changes
per frame, and may wrap around without issues.

Henrik
