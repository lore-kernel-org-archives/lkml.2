Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2BFHZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:25:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63379 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2BFHZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:25:41 -0500
Date: Sun, 5 Feb 2012 23:25:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chasedouglas@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
Message-ID: <20120206072535.GB14139@core.coreip.homeip.net>
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
 <4F2B24AC.1020408@gmail.com>
 <20120203072725.GA6914@polaris.bitmath.org>
 <4F2D7730.3090704@gmail.com>
 <20120205075906.GA7698@polaris.bitmath.org>
 <4F2EB8C8.9090102@gmail.com>
 <20120205194036.GA2566@polaris.bitmath.org>
 <4F2F08CD.2010806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2F08CD.2010806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 11:55:09PM +0100, Chase Douglas wrote:
> On 02/05/2012 08:40 PM, Henrik Rydberg wrote:
> >>> Besides leaving a possible giant stack crash in your code, it assumes
> >>> memory is somehow magically allocated. Not good practise in low-level
> >>> programming. You wouldn't use a template this way, would you?
> >>
> >> No, which is why I think this interface is bad. I should be able to
> >> dynamically set the size of the array, but it's not possible with this
> >> interface.
> > 
> > It is possible (using num_slots == 0 or creating your own struct), but
> > not ideal, granted. The patch serves the purpose of definining the
> > binary interface, the rest is up to userland.
> > 
> >> I think the implementation is fine in terms of how the plumbing works. I
> >> just don't think this macro should be included. Make the user create the
> >> struct themselves:
> >>
> >> In linux/input.h:
> >>
> >> struct input_mt_request {
> >> 	__u32 code;
> >> 	__s32 values[];
> >> };
> > 
> > The above (the first) version is not ideal either, since it cannot be
> > used as it is.
> > 
> >> It could be argued that we should leave the macro around for people who
> >> want to statically define the size of the request, but I think that is
> >> leading them down the wrong path. It's easier, but it will lead to
> >> broken code if you pick the wrong size.
> > 
> > Rather than creating both a suboptimal static and a suboptimal dynamic
> > version, removing the struct altogether is tempting. All that is
> > really needed is a clear definition of the binary interface. The rest
> > can easily be set up in userland, using whatever method is preferred.
> 
> I'm normally not a fan of static functions in header files, but maybe it
> would be a good solution here:
> 
> struct input_mt_request {
> 	__u32 code;
> 	__s32 values[];
> };
> 
> static struct input_mt_request *
> linux_input_mt_request_alloc(int num_slots) {
> 	return (struct input_mt_request *)malloc(
> 		sizeof(__u32) + num_slots * sizeof(__s32));
> }

Gah, can we please leave it to userspace programs to define and allocate
the structure as it makes most sense for them. As far as kernel goes we
just want to document that we'll need a u32 and a place to put N s32s.
How they are allocated we do not care at all. It could be on stack
(which does not have the same limits as kernel stack) or in the heap.

Thanks.

-- 
Dmitry
