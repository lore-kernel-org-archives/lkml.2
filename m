Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2BAFIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:08:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2BAFIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:08:47 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=i21a-V6_04JO_ioW9UkA:9 a=yNfGTjJcR2_DZb0oAEgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328072925.5882.57.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 01 Feb 2012 00:08:45 -0500
In-Reply-To: <20120131194813.GA12074@elte.hu>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
	 <1327936060.22710.165.camel@gandalf.stny.rr.com>
	 <20120131194813.GA12074@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 20:48 +0100, Ingo Molnar wrote:

> Attached. (you need to run it through make oldconfig and use the 
> defaults.)

Hmm, I'm not able to reproduce it.

Could you apply this patch and run it again. I'm interested in what was
at the location when it tried to do the conversion.

Thanks!

-- Steve

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 6173ca6..da12264 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -58,13 +58,17 @@ static void __jump_label_transform(struct jump_entry *entry,
 			size = JUMP_LABEL_NOP_SIZE;
 			code.jump = 0xe9;
 			code.offset = entry->target - (entry->code + size);
-		} else
+		} else {
+			unsigned char *ins = ip;
 			/*
 			 * The location is not a nop that we were expecting,
 			 * something went wrong. Crash the box, as something could be
 			 * corrupting the kernel.
 			 */
+			printk("Unknown op at %pS (%02x:%02x:%02x:%02x:%02x)\n",
+			       ip, ins[0], ins[1], ins[2], ins[3], ins[4]);
 			BUG();
+		}
 	} else {
 		/*
 		 * We are disabling this jump label. If it is not what


