Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0KWQ4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:56:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51796 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0KWQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X1vnlCiUJM56Hwegx6p6X1zqGhxxKjpWuW8BVekhX2nZoMjyici7kTA24sfffY2ksm
         jpU+/wvrqX5BmZnGyT9DM4Ea5tPXaHsNzuwGnk081YIv5wFcdVHaLQdX0+3wh5LdTpbR
         28NKBfm5qWQMNXuW5FZxqu/BRw94oX9BVdKo0=
Subject: Re: [PATCH 4/9] AF_UNIX: find the recipients for multicast messages
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        gorcunov@openvz.org, adobriyan@gmail.com, lennart@poettering.net,
        kay.sievers@vrfy.org, ian.molton@collabora.co.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1290528517.3046.91.camel@edumazet-laptop>
References: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk>
	 <1290450982-17480-4-git-send-email-alban.crequy@collabora.co.uk>
	 <20101122.110519.39205345.davem@davemloft.net>
	 <20101123150315.4e67a139@chocolatine.cbg.collabora.co.uk>
	 <1290528517.3046.91.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 17:56:40 +0100
Message-ID: <1290531400.3046.117.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm, just thought about lockless again, and we had same multicast
problem on udp as well.

We are forced to hold a lock (to forbid concurrent deletes), or we might
going through one 'about to be removed' socket and abort the iteration
in the middle. Some sockets would not receive a copy of the message.

(UDP sockets using SLAB_DESTROY_BY_RCU, we could even have multiple
copies sent to some sockets, if the removed socket is re-inserted in
front of chain because of instant reuse)

To have a true lockless path, you would need to restart the full scan if
you notice a delete was done during the iteration, eventually using a
sequence number per chain. That would be expensive, because you have to
undo all the socket accumulation (refcount) done during the lookup,
before restart the thing.

To avoid starvation, getting a lock at the second iteration would be
good ;)



