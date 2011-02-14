Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab1BNS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:29:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47525 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1BNS3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:29:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=wMT4zMUZ9TQef6ESNm4bbzsZ8RDEtxK9ePZsVVBgctNAiE88bpk7GcU4yIGukFN7s4
         2I/Kqd8EyE7UTnPW18griz1m0b3FcoG505CpgwvaJ8wkHLTSDUNCrMQFH+2sRdUx9/sG
         eVmwBHLX+QQSOpyZJpHzvcunEROyHiBUXM+2Q=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcp23s08: support mcp23s17 variant
References: <1297699964-20527-1-git-send-email-jacmet@sunsite.dk>
	<AANLkTi=pWV+tfD6YGpKbzTkvLVoLXtGA41QRaaF=VFeq@mail.gmail.com>
Date: Mon, 14 Feb 2011 19:29:50 +0100
In-Reply-To: <AANLkTi=pWV+tfD6YGpKbzTkvLVoLXtGA41QRaaF=VFeq@mail.gmail.com>
	(Grant Likely's message of "Mon, 14 Feb 2011 10:13:01 -0700")
Message-ID: <87r5bacvvl.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

Hi,

 >> -       return (status < 0) ? status : rx[0];
 >> +
 >> +       if (mcp->type == MCP_TYPE_S17) {
 >> +               tx[1] <<= 1;
 >> +
 >> +               status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, 2);
 >> +               return (status < 0) ? status : (rx[0] | (rx[1] << 8));
 >> +       } else {
 >> +               status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, 1);
 >> +               return (status < 0) ? status : rx[0];
 >> +       }

 Grant> Rather than checking ->type for every transaction, would a set of
 Grant> callbacks for each type be better?  It would probably have lower
 Grant> overhead and be simpler to maintain.

We could. I didn't do it because the 8bit and 16bit cases are very
similar, and checking a simple integer is presumably a lot faster than
the spi access - But I can rework the patch if you insists.

 >> +++ b/include/linux/spi/mcp23s08.h
 >> @@ -2,21 +2,24 @@
 >>  /* FIXME driver should be able to handle IRQs...  */
 >> 
 >>  struct mcp23s08_chip_info {
 >> -       bool    is_present;             /* true iff populated */
 >> -       u8      pullups;                /* BIT(x) means enable pullup x */
 >> +       bool            is_present;     /* true if populated */
 >> +       unsigned        pullups;        /* BIT(x) means enable pullup x */
 >>  };

 Grant> Unrelated whitespace changes.

I wouldn't call it unrelated. It's to ensure it still lines up after the
s/u8/unsigned/.

-- 
Bye, Peter Korsgaard
