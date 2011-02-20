Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1BTS0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 13:26:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53615 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab1BTS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 13:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ND0t5R+bn6gCkpT/8FeT1Y4RQg9qdvVXVBc/sA452sYb0riTTkkV3bEKlHGqzDQjag
         zVa8CaObLU2f3wZCcViKmtcghH0mJ26M3Yt6OCAEfLtEaXE5BllB05Z9l+nQZ46oZ2BP
         jCLjOWGBfmztJBoC1EeOfAeNMo4FsRoJ5x5Gk=
Date: Sun, 20 Feb 2011 19:24:37 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Quentin Barnes <qbarnes@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: bug in arm_kprobe_decode_insn
Message-ID: <20110220182437.GA24789@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

In arch/arm/kernel/kprobes-decode.c there's a function arm_kprobe_decode_insn
which does:

} else if ((insn & 0x0e000000) == 0x0c400000) {
...

This is always false, so code below is dead.

I'm not sure about what was intended here, but I think this change might be correct:

diff --git a/arch/arm/kernel/kprobes-decode.c b/arch/arm/kernel/kprobes-decode.c
index 2c1f005..8f6ed43 100644
--- a/arch/arm/kernel/kprobes-decode.c
+++ b/arch/arm/kernel/kprobes-decode.c
@@ -1437,7 +1437,7 @@ arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 
 		return space_cccc_1100_010x(insn, asi);
 
-	} else if ((insn & 0x0e000000) == 0x0c400000) {
+	} else if ((insn & 0x0e000000) == 0x0c000000) {
 
 		return space_cccc_110x(insn, asi);
 
--


I found this bug by coccinelle (http://coccinelle.lip6.fr/).
(The script is ugly, so I'm not attaching it here)


Marcin Slusarz
