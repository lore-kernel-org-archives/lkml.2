Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1EHT5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:57:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46971 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1EHT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=pjwstk.edu.pl; s=google;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BtpIdZ0T+w3CC3qhzeIz+1HzG7zjNKmBguYkLY6uTS3vIZU4zDetX1hop/WpM/dRZg
         LtSOfgOVG01gf3Fsz3jGyB9pstVh4Oyd0Ar0dYZmSSQVW1xvelMraNAjf7zejviEXlX1
         ulCKZVKBRQ+vNFDP9dw2ZOgBhtYMR6vuwaC5M=
MIME-Version: 1.0
Date: Sun, 8 May 2011 21:57:25 +0200
Message-ID: <BANLkTik7WyQ977-+8XapTgBrVRMyexyHKg@mail.gmail.com>
Subject: Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.
From: Filip Palian <s3810@pjwstk.edu.pl>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: security@kernel.org, oss-security@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Structures "l2cap_conninfo" and "rfcomm_conninfo" have one padding
byte each. This byte in "cinfo" is copied to userspace uninitialized.

patch no.1:
-- cut --
--- a/net/bluetooth/l2cap_sock.c        2011-05-04 03:59:13.000000000 +0100
+++ b/net/bluetooth/l2cap_sock.c        2011-05-08 18:57:20.000000000 +0100
@@ -446,6 +446,7 @@ static int l2cap_sock_getsockopt_old(str
                        break;
                }

+               memset(&cinfo, 0, sizeof(cinfo));
                cinfo.hci_handle = l2cap_pi(sk)->conn->hcon->handle;
                memcpy(cinfo.dev_class, l2cap_pi(sk)->conn->hcon->dev_class, 3);

-- cut --

patch no.2:
-- cut --
--- a/net/bluetooth/rfcomm/sock.c       2011-05-04 03:59:13.000000000 +0100
+++ b/net/bluetooth/rfcomm/sock.c       2011-05-08 19:00:24.000000000 +0100
@@ -787,6 +787,7 @@ static int rfcomm_sock_getsockopt_old(st

                l2cap_sk = rfcomm_pi(sk)->dlc->session->sock->sk;

+               memset(&cinfo, 0, sizeof(cinfo));
                cinfo.hci_handle = l2cap_pi(l2cap_sk)->conn->hcon->handle;
                memcpy(cinfo.dev_class,
l2cap_pi(l2cap_sk)->conn->hcon->dev_class, 3);
-- cut --

Found by Marek Kroemeke and Filip Palian. Special thanks to Vasiliy
Kulikov for verifying this bug.


Best regards.
