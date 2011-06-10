Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1FJF6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:58:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41192 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1FJF6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=fqHY3G8dYNScxHAv7yNhpp32Dtshx629m7rh8afmvDN6mmyVgc1cSdFhXs+plma9ud
         AunH6JoXuDRtzytkjTZVh8x7vIVzdks1lErryL1BA70q4Zh3XSR45ly97QGwemY6DQ8s
         TzaG826UYFE/E/DimCICzLaWbsRD2yKiviLfo=
MIME-Version: 1.0
In-Reply-To: <20110610055558.GA1832@dell>
References: <yunboy7a2so.fsf@aiko.keithp.com>
	<99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com>
	<20110609083345.GA2894@dell.ccr.corp.intel.com>
	<yuny61b3pnm.fsf@aiko.keithp.com>
	<99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com>
	<20110610055558.GA1832@dell>
Date: Fri, 10 Jun 2011 14:58:50 +0900
Message-ID: <BANLkTim4F8ZvWPMHSXpcBj9Eb2uFThcz4w@mail.gmail.com>
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key requirements"
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Waldemar.Rymarkiewicz@tieto.com, keithp@keithp.com, padovan@profusion.mobi,
        marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Fri, Jun 10, 2011 at 2:55 PM, Johan Hedberg <johan.hedberg@gmail.com> wrote:
> Hi,
>
> On Thu, Jun 09, 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
>> >I re-pair'ed using a manually entered a 16 digit pin, but now
>> >DUN setup doesn't succeed at all.
>>
>> Did you try to remove all stored link keys and start again?
>> If you already have a pincode which is insecure you have to remove it manually.
>>
>> Try 'hciconfig hciX noauth noencrypt ' before.
>>
>> Check syslog and switch debug on in the kernel first.
>
> So I just realized that the BITE tests were only done for mgmtops.c and
> not hciops.c. One critical difference is that conn->key_type will not be
> set (or actually set to 0xff) for connections which happen after the
> initial pairing has occurred. We're right now testing a one-line patch
> which might fix the issue. Luiz will send it soon if it turns out to
> work fine.

So the fix we were testing looks like this:

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 2f5ae53..b309f84 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -673,8 +673,8 @@ auth:
        if (test_and_set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend))
                return 0;

-       hci_conn_auth(conn, sec_level, auth_type);
-       return 0;
+       if (!(hci_conn_auth(conn, sec_level, auth_type)))
+               return 0;

 encrypt:
        if (conn->link_mode & HCI_LM_ENCRYPT)

-- 
Luiz Augusto von Dentz
Computer Engineer
