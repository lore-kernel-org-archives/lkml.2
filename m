Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0HIUeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:34:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33308 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0HIUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TWTV6tF/ZSRsJOAjrjWvXCQEEF7ovCX9K2UcrKF7Fis8ByZU1klRdLqj6Tw0vjFjGI
         O0T7vZ4y1+GpOwqNd/dwB8LBA5bVRCW8AIc17iAF6tQ2ET60S4uIEbISQqplnL2IZvPx
         RiFzkYmabhAEH1krvMtxTGk8sDkjpUV0VOKkc=
Date: Tue, 10 Aug 2010 00:34:03 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Sven Eckelmann <sven.eckelmann@gmx.de>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: batman-adv: design suggestions
Message-ID: <20100809203403.GA16183@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I was reading batman-adv sources and noted:


1) Some incoming packets may cause a storm of error logs, such as at
routing.c:862


	if (icmp_packet->msg_type != ECHO_REQUEST) {
		pr_warning("Warning - can't forward icmp packet from %pM to "
			   "%pM: ttl exceeded\n", icmp_packet->orig,
			   icmp_packet->dst);

  Any flooding bad guy is able to fill our disks with logs.
  This should be logged only at some slow rate (e.g. 5 logs/sec) or as
  pr_debug().


2) It seems to me that NF_HOOK() at hard-interface.c:458 is misused:

    ...
	ret = NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, dev, NULL,
		      batman_skb_recv_finish);
	if (ret != 1)
		goto err_out;

	/* packet should hold at least type and version */
	if (unlikely(skb_headlen(skb) < 2))
		goto err_free;

	/* expect a valid ethernet header here. */
	if (unlikely(skb->mac_len != sizeof(struct ethhdr)
				|| !skb_mac_header(skb)))
		goto err_free;
    ...

    static int batman_skb_recv_finish(struct sk_buff *skb)
    {
        return NF_ACCEPT;
    }

  As I understand, if there is any hook that returns NF_STOLEN, then skb
  is leaked.


Thanks,
Vasiliy.
