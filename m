Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0FZNTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 09:19:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37918 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0FZNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 09:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=LSFN/bzavbBPNgWVNA5bCoFu+V3p9tlKniVDy5HFHZiWP9yGDSHiJaovlTZD7uLj1j
         4Hbnoj2vo/1jm+2wYojJMb7BYoo0xDA9R7HRR9gCO4vyWcTtvz6rd4uDJ5ZW9bm62uFN
         Us/fTgPqT2O6ESQgddP52fksxLT4oxMpUa60s=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100620071446.GA21743@localhost>
References: <20091208211647.9B032B151F@basil.firstfloor.org> 
	<AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com> 
	<20100619132055.GK18946@basil.fritz.box> <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com> 
	<20100619133000.GL18946@basil.fritz.box> <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com> 
	<20100619140933.GM18946@basil.fritz.box> <AANLkTilF6m5YKMiDGaTNuoW6LxiA44oss3HyvkavwrOK@mail.gmail.com> 
	<20100619195242.GS18946@basil.fritz.box> <AANLkTikMZu0GXwzs6IeMyoTuhETrnjZ1m5lI9FTauYBA@mail.gmail.com> 
	<20100620071446.GA21743@localhost>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sat, 26 Jun 2010 15:18:52 +0200
Message-ID: <AANLkTimv1S4BuyGFyuBld0Wn6ncz7JUnMiPis-HlN3Tb@mail.gmail.com>
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft page 
	offlining
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

On Sun, Jun 20, 2010 at 9:14 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Sun, Jun 20, 2010 at 02:19:35PM +0800, Michael Kerrisk wrote:
>> Hi Andi,
>> On Sat, Jun 19, 2010 at 9:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> .TP
>> >> .BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
>> >> Soft offline the pages in the range specified by
>> >> .I addr
>> >> and
>> >> .IR length .
>> >> This memory of each page in the specified range is copied to a new page,
>> >
>> > Actually there are some cases where it's also dropped if it's cached page.
>> >
>> > Perhaps better would be something more fuzzy like
>> >
>> > "the contents are preserved"
>>
>> The problem to me is that this gets so fuzzy that it's hard to
>> understand the meaning (I imagine many readers will ask: "What does it
>> mean that the contents are preserved"?). Would you be able to come up
>> with a wording that is a little miore detailed?
>
> That is, MADV_SOFT_OFFLINE won't lose data.
>
> If a process writes "1" to some virtual address and then called
> madvice(MADV_SOFT_OFFLINE) on that virtual address, it can continue
> to read "1" from that virtual address.
>
> MADV_SOFT_OFFLINE "transparently" replaces the underlying physical page
> frame with a new one that contains the same data "1". The original page
> frame is offlined, and the new page frame may be installed lazily.

Thanks. That helps me come up with a description that is I think a bit clearer:

       MADV_SOFT_OFFLINE (Since Linux 2.6.33)
              Soft offline the pages in the range specified by
              addr and length.  The memory of each page in the
              specified  range  is  preserved (i.e., when next
              accessed, the same content will be visible,  but
              in  a new physical page frame), and the original
              page is offlined  (i.e.,  no  longer  used,  and
              taken  out  of  normal  memory management).  The
              effect of  the  MADV_SOFT_OFFLINE  operation  is
              invisible  to  (i.e., does not change the seman-
              tics of) the calling process. ...

The actual patch for man-pages-3.26 is below.

Cheers,

Michael

--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -163,12 +163,14 @@ Soft offline the pages in the range specified by
 .I addr
 and
 .IR length .
-The memory of each page in the specified range is copied to a new page,
+The memory of each page in the specified range is preserved
+(i.e., when next accessed, the same content will be visible,
+but in a new physical page frame),
 and the original page is offlined
 (i.e., no longer used, and taken out of normal memory management).
 The effect of the
 .B MADV_SOFT_OFFLINE
-operation is normally invisible to (i.e., does not change the semantics of)
+operation is invisible to (i.e., does not change the semantics of)
 the calling process.
 This feature is intended for testing of memory error-handling code;
 it is only available if the kernel was configured with
