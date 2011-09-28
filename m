Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1I1Mp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:45:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1I1Mp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:45:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH V4] mtd: Add DiskOnChip G3 support
Date: Wed, 28 Sep 2011 14:45:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1316633266-21312-1-git-send-email-robert.jarzmik@free.fr> <201109271539.21533.arnd@arndb.de> <878vp96fhl.fsf@free.fr>
In-Reply-To: <878vp96fhl.fsf@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281445.47715.arnd@arndb.de>
X-Provags-ID: V02:K0:N2uq83/rrKz1TIo+9aiU+YrgXP20qgz5GUA0NBtwVtD
 WCyfm0FebrXmukhybJtn1ZiEHylGrgOYT5Np3xdxYthYu48Jxb
 MqzK9q8diQtWm51pMITgFB1LA5Gf0uLoa4KBi8IOzEnfyYSmDe
 QsnzgeqIOFHOMlxHCPYIepx/Xh1byvAIRZTIkxEgTeoF7HP1Iq
 1Z65bkIYckKtRKHb9hAPDensUWLLFNdyJkfGj6AN7WwqDPvR8M
 4RRKL9gRVfh9iyeOk3uhsFsHGo6/zXxLrdyljmCOBTMndys0ZT
 kpiE6Vl8jKDxS/2xB3t/IV33ysuc70T4FPYWt/q6S6tiBQ0hYW
 asYPJlYwExGD8OlwTqAs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Robert Jarzmik wrote:
> >
> > Really, passing the entire register name into an inline function is much
> > preferred over string concatenation, because it lets you grep for where
> > certain definitions are used.
> Right. But how do handle the "#seq" then ?
> 
> The whole point here is to write humanly readable debug messages. A message of
> the like "doc_flashsequence: 48 SET_PLANE1" is much better than
> "doc_flashsequence: 48", don't you think ?
> 
> If we consider to loose that debugging messages, it's way easier to drop the "do
> .. while(0)" sequences, and just keep the register write.
> 
> Now if you're convinced removing the "SET_PLANE1" debugging message is less
> important that ability to grep the full register name, why not, but from a
> maintenance point of view I would prefer letting the "macroness" in.

I generally recommend removing debug messages like this entirely from
production code. If you need them on production systems, that is an indication
that the code quality is not good enough. Enabling the debug output like
this also creates a lot of almost identical strings, which you don't need
if you turn it into an extern function that does

	static const char docseq[] = {
		[DOC_SEQ_RESET]		 = "reset",
		[DOC_SEQ_PAGE_SIZE_532]	 = "page_size_532",
	};
	dev_dbg(dev, "doc_flashSequence: %02x %s\n", docseq[seq]);

with exactly the same output.

Or you could turn the entire tracing into trace events and do the parsing
in user space, which seems appropriate if you frequently need to trace
these.

	Arnd
