Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1JMJ5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:57:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63378 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1JMJ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:57:40 -0400
Date: Thu, 13 Oct 2011 11:57:34 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
Message-ID: <20111013095734.GA16748@alberich.amd.com>
References: <1318370975-10817-1-git-send-email-jacob.shin@amd.com>
 <4E94D4E7.5010001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E94D4E7.5010001@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 04:44:39PM -0700, H. Peter Anvin wrote:
> On 10/11/2011 03:09 PM, Jacob Shin wrote:
> > The entire HT hole and also the unused address range before that hole
> > need to be excluded from direct mapping. Otherwise speculative
> > accesses to that reserved region can happen which cause machine
> > checks.

> BARF!

> This is completely insane ad hockery when all that really should
> need to happen is marking the HT region RESERVED, which should be
> possible on any HT-equipped processor.

Great, thanks for this hint, I would never have thought that ...  but
wait, guess what, we have tried this already.

Initially we had following situation:

  BIOS-e820: 0000000100000000 - 000000e038000000 (usable)
  BIOS-e820: 000000e038000000 - 000000fd00000000 (reserved)
  BIOS-e820: 0000010000000000 - 0000011fff000000 (usable)
 ...
 init_memory_mapping: 0000000100000000-0000011fff000000
  0100000000 - 11fc0000000 page 1G
  11fc0000000 - 11fff000000 page 2M
 kernel direct mapping tables up to 11fff000000 @ 11ffeffc000-11fff000000

But MCEs due to speculative accesses happened to the reserved region
before the HT hole.

So what is the point in including address space below TOM2 not backed
with memory in kernel's direct mapping? For similar reserved space
before 4GB we don't do this.

Instead of barfing, some more constructive feedback would be
appreciated.


Thanks,

Andreas
