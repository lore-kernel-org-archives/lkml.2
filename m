Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871Ab1ITNZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:25:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1ITNZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:25:46 -0400
Date: Tue, 20 Sep 2011 15:25:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Hogan <james.hogan@imgtec.com>
Cc: David Herrmann <dh.herrmann@googlemail.com>, linux-input@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] hidraw: protect hidraw_disconnect() better
In-Reply-To: <4E785309.2000807@imgtec.com>
Message-ID: <alpine.LNX.2.00.1109201525020.13109@pobox.suse.cz>
References: <4E7754DA.30108@imgtec.com> <CANq1E4QRkdd_nTORBKshBBX1tn8JxQ1U4OPaogBcrM7mOnuRhQ@mail.gmail.com> <4E785309.2000807@imgtec.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, James Hogan wrote:

> >> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> >> ---
> >>  drivers/hid/hidraw.c |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> >> index c79578b..a8c2b7b 100644
> >> --- a/drivers/hid/hidraw.c
> >> +++ b/drivers/hid/hidraw.c
> >> @@ -510,13 +510,12 @@ void hidraw_disconnect(struct hid_device *hid)
> >>  {
> >>        struct hidraw *hidraw = hid->hidraw;
> >>
> >> +       mutex_lock(&minors_lock);
> >>        hidraw->exist = 0;
> >>
> >>        device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
> > 
> > This does not destroy any open file descriptor and we haven't
> > registered any kind of hook so hidraw_destroy() will not be called
> > here.
> > This seems safe to me.
> > We also do not check for hidraw->exist on *_open() callback so
> > including this in the critical section seems fine.
> 
> That's good then. Thanks for checking it.
> 
> > 
> >> -       mutex_lock(&minors_lock);
> >>        hidraw_table[hidraw->minor] = NULL;
> >> -       mutex_unlock(&minors_lock);
> >>
> >>        if (hidraw->open) {
> >>                hid_hw_close(hid);
> >> @@ -524,6 +523,7 @@ void hidraw_disconnect(struct hid_device *hid)
> >>        } else {
> >>                kfree(hidraw);
> >>        }
> >> +       mutex_unlock(&minors_lock);
> >>  }
> >>  EXPORT_SYMBOL_GPL(hidraw_disconnect);
> >>
> >> --
> >> 1.7.2.3
> > 
> > Nice catch. I've tested it on linux-next tree and I can confirm the
> > bug. The fix seems ok to me.

Good, thanks. I have now applied it with your Tested-by:, please shout if 
you don't want that.

> Shall I resend without RFC? I'll add Cc: <stable@kernel.org> too if
> there aren't objections.

stable@kernel.org wouldn't work anyway due to kernel.org being down ...

-- 
Jiri Kosina
SUSE Labs
