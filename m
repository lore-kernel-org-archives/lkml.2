Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2GZTM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:12:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44396 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2GZTM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:12:28 -0400
Message-ID: <50119697.5050807@lwfinger.net>
Date: Thu, 26 Jul 2012 14:12:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neal Cardwell <ncardwell@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Regression in staging:r8712u since 3.4 merge
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kernel 3.4, driver r8712u has yielded intermittent errors when connected 
to a secure connection. With Firefox, the message is "Secure Connection Failed: 
SSL received a record with an incorrect Message Authentication Code (Error code: 
ssl_error_bad_mac_read)". A retry may work eventually, When using wget with an 
https URL, the error message is "SSL3_GET_RECORD: decryption failed or bad 
record mac".

This regression is the basis for https://bugzilla.kernel.org/show_bug.cgi?id=45071.

Although intermittent, I managed to bisect the problem. The bad commit is

==========================================================================
commit c8628155ece363487b57d33441ea0359018c0fa7
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Sun Mar 18 11:07:47 2012 +0000

     tcp: reduce out_of_order memory use

     With increasing receive window sizes, but speed of light not improved
     that much, out of order queue can contain a huge number of skbs, waiting
     to be moved to receive_queue when missing packets can fill the holes.

     Some devices happen to use fat skbs (truesize of 4096 + sizeof(struct
     sk_buff)) to store regular (MTU <= 1500) frames. This makes highly
     probable sk_rmem_alloc hits sk_rcvbuf limit, which can be 4Mbytes in
     many cases.

     When limit is hit, tcp stack calls tcp_collapse_ofo_queue(), a true
     latency killer and cpu cache blower.

     Doing the coalescing attempt each time we add a frame in ofo queue
     permits to keep memory use tight and in many cases avoid the
     tcp_collapse() thing later.

     Tested on various wireless setups (b43, ath9k, ...) known to use big skb
     truesize, this patch removed the "packets collapsed in receive queue due
     to low socket buffer" I had before.

     This also reduced average memory used by tcp sockets.

     With help from Neal Cardwell.

     Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
     Cc: Neal Cardwell <ncardwell@google.com>
     Cc: Yuchung Cheng <ycheng@google.com>
     Cc: H.K. Jerry Chu <hkchu@google.com>
     Cc: Tom Herbert <therbert@google.com>
     Cc: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
     Acked-by: Neal Cardwell <ncardwell@google.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>
============================================================================

As every other network driver is OK with this patch, I know the problem is in 
r8712u. Do you have any thoughts on what it might be doing wrong to cause this 
problem?

Thanks,

Larry

