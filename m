Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1BXTI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:08:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61143 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab1BXTI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:08:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ntx8l6bQJVFuNt9KBFc8v5td+f1VVJALQ6ROc8RtL3AI9eXLKFZCzVoAFXhdPoAO6X
         AK9anKhMgBPi3ysrcEO09S5BfPK5Cv5CG2IynIDOigV/we6pm9Y0eIr7PTsz/UWR475g
         SQbFlpbLuvC5eXuTlsgS3IOO8J+ASA3bxi2lY=
MIME-Version: 1.0
In-Reply-To: <1298568347.6376.3.camel@gandalf.stny.rr.com>
References: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
	<20110224160828.GA888@home.goodmis.org>
	<20110224170619.GA7925@suse.de>
	<1298568347.6376.3.camel@gandalf.stny.rr.com>
Date: Thu, 24 Feb 2011 19:08:27 +0000
X-Google-Sender-Auth: 5C-K143wWvQWOzLVaiDFipADzF8
Message-ID: <AANLkTinBFFU5c_kcXGSnJA-ycY6j7EeKvwAFb59iWMHn@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: remove null checks before kfree
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 5:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-02-24 at 09:06 -0800, Greg KH wrote:
>> On Thu, Feb 24, 2011 at 11:08:29AM -0500, Steven Rostedt wrote:
>> > On Tue, Feb 22, 2011 at 03:53:40AM -0500, Ilia Mirkin wrote:
>> > > This patch was created with the following semantic patch:
>> > >
>> > > // <smpl>
>> > > @@
>> > > expression E;
>> > > @@
>> > >
>> > > - if (E != NULL) kfree(E);
>> > > + kfree(E);
>> > > // </smpl>
>> >
>> > OK, so when will we be removing the unlikely() from the implementations
>> > of kfree()?
>> >
>> >     if (unlikely(ZERO_OR_NULL_PTR(block)))
>> >                     return;
>>
>> Have you run the tool that checks for unlikely being true here?  Odds
>> are, even with all of these changes, the large majority of the time
>> kfree is called, it has a valid pointer.
>
> Crap, all my saved output files were in the /tmp directory and has since
> been purged. I can reboot into the unlikely tracing kernel again, but
> that may have to wait. I usually just do that at end of year as a
> cleanup.
>
> I can't remember exactly where kfree came in, but IIRC it was on the
> list. Maybe not that high though.

FWIW my reasoning for doing this was that generally the reason you're
freeing something is because you allocated it, so kfree(NULL) happens
rarely -- error paths, conditional features, etc. If you actually
expect the argument to be NULL often, then you would do something like
if (unlikely(x)) kfree(x). This is done a few times in the core
kernel. I think it makes more sense for kfree to keep the unlikely
since in cold paths it won't matter and in hot paths where it is often
NULL, there should be a conditional at the call site. [I'm sure you'll
note the lack of an attached benchmark... this is just what makes
sense to me.]

  -ilia
