Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1FEBPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 21:15:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57276 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab1FEBPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 21:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-type:content-transfer-encoding;
        b=SslX7PSyg8sCqSRrMAuPoqrFqFmJOY4zmDoVqu+tBjf3BqG0gnH4gNgzeormYfhFCU
         bbG2bJNbF8Fj6WIi+C9oFvCVa1OBCwwv1uxU80r9ffz4PyFmw5spxIj6R7unE1AZ6F8d
         OhamUuM4nWX3iIg6LASoGyZyBZOCd62dpV7nA=
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <BANLkTimpYniHhN6ccMXN7Lx3xDdK6sC+FQ@mail.gmail.com>
References: <BANLkTimpYniHhN6ccMXN7Lx3xDdK6sC+FQ@mail.gmail.com>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sun, 5 Jun 2011 03:14:49 +0200
Message-ID: <BANLkTikRU1qrBPoaQT9tbgryXV92YHZzpw@mail.gmail.com>
Subject: [PATCH] e100: Fix inconsistency in bad frames handling
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

In e100 driver it seems that the intention was to accept bad frames in
promiscuous mode and loopback mode.
I think this is evident because of the following code in the driver:

if (nic->flags & promiscuous || nic->loopback) {
               config->rx_save_bad_frames = 0x1;       /* 1=save, 0=discard */
               config->rx_discard_short_frames = 0x0;  /* 1=discard, 0=save */
               config->promiscuous_mode = 0x1;         /* 1=on, 0=off */
       }


However this intention is not really realized because bad frames are
discarded later by SW check.
This patch finally honors the above intention, making the RX code to
let bad frames to pass when the NIC is in promiscuous or loopback
mode.

This helped me a lot to debug an FPGA ethernet core.
Maybe it can be also useful to someone else..

Thanks
Andrea

 --- drivers/net/e100_orig.c     2011-06-14 23:29:38.322267075 +0200
+++ drivers/net/e100.c  2011-06-14 23:34:10.700791472 +0200
@@ -1975,7 +1975,8 @@ static int e100_rx_indicate(struct nic *
       skb_put(skb, actual_size);
       skb->protocol = eth_type_trans(skb, nic->netdev);

-       if (unlikely(!(rfd_status & cb_ok))) {
+       if (unlikely(!(nic->flags & promiscuous || nic->loopback) &&
+           !(rfd_status & cb_ok))) {
               /* Don't indicate if hardware indicates errors */
               dev_kfree_skb_any(skb);
       } else if (actual_size > ETH_DATA_LEN + VLAN_ETH_HLEN) {
