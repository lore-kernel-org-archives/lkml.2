Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab2CVO7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:59:00 -0400
Received: from mga12.intel.com ([143.182.124.36]:10266 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754328Ab2CVO66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <1332427986.2218.53.camel@falcor>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
	<20120322142212.GV6589@ZenIV.linux.org.uk>
	<1332427986.2218.53.camel@falcor>
Date: Thu, 22 Mar 2012 16:58:43 +0200
Message-ID: <CALLzPKa8zz9g_YrRzgJty2BRZe=9_Gt5cH+cXAzjRy-B8TaimA@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 4:53 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Thu, 2012-03-22 at 14:22 +0000, Al Viro wrote:
>> On Wed, Mar 21, 2012 at 02:54:15PM -0400, Mimi Zohar wrote:
>> > If a file is closed before it is munmapped, __fput() is called with
>> > the mmap_sem taken.  With IMA-appraisal enabled, this results in an
>> > mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count
>> > to defer __fput() being called until after the mmap_sem is released.
>>
>> NAK.  It's far too heavy-weight for what's a very common path.  Worse,
>> it causes different locking conditions on IMA and non-IMA kernels and makes
>> bugs harder to spot.  Rejected with extreme prejudice; please, fix your
>> locking instead.
>
> Al, thanks for replying!  I realize you are very prejudiced against IMA,
> but have you taken a look at IMA-appraisal?  It probably would have been
> better if we used another name in order to avoid this prejudice, but
> unfortunately we didn't.  :(  IMA-appraisal is about enforcing file
> integrity.
>
>> BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
>> be enough to paper over your problem anyway.
>>

In current solution, deferred call can be added directly to __fput and checking
if mmap_sem is locked.

>> Final fput() *can* happen under mmap_sem.  Period.
>
> I think I got that loud and clear; otherwise we wouldn't have come up
> with deferring the __fput().  We have a very real problem here - writing
> extended attributes requires taking the i_mutex.  I'm open to any
> suggestions.
>
> thanks,
>
> Mimi
>
