Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab2J3Ol6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:41:58 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:57526 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab2J3Ol5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:41:57 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 10:41:57 EDT
Message-Id: <201210301426.q9UEQkI7007209@thirdoffive.cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: davem@davemloft.net, dwmw2@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] pppoatm: fix race condition with destroying of vcc
In-reply-to: <1350926091-12642-2-git-send-email-krzysiek@podlesie.net>
Date: Tue, 30 Oct 2012 10:26:46 -0400
X-NRLCMF-Spam-Score: () hits=-1.01
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1350926091-12642-2-git-send-email-krzysiek@podlesie.net>,Krzysztof Mazur writes:
>The pppoatm_send() calls vcc->send() and now also checks for
>some vcc flags that indicate destroyed vcc without proper locking.
...
>The vcc_sendmsg() uses lock_sock(sk). This lock is used by
>vcc_release(), so vcc_destroy_socket() will not be called between
>check and during ->send(). The vcc_release_async() sets ATM_VF_CLOSE,
>but it should be safe to call ->send() after it, because
>vcc->dev->ops->close() is not called.

as i recall from way back, this shouldnt be necessary.  closing a vcc
for an attached protocol isnt supposed to require addtional locking
or synchronization.

vcc_release() locks the socket and vcc_destroy_socket() calls the device's
vcc close routine and pushes a NULL skb to the attached protocol.
this NULL push is supposed to let the attached protocol that no more
sends and recvs can be handled. 

that said, the order for the device vcc close and push does seem
reversed.  since i imagine there could be a pending pppoatm_send()
during this interval.  the push of the NULL skb is allowed to wait for
the subprotocol to finish its cleanup/shutdown.
