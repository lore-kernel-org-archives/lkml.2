Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0JOPyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:54:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36045 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JOPyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f+A3A+64Lf3iB5es8aWtnFN6a91fMjg1QFtM1DAa4orREukPNESPykVsZaExOxzmcv
         5Ju/IYwjdP7gNWHboJ/lkeTae5vy6I+wAXHBhRCISvRY17BhyglB07fXvQ3R8ABRdVl3
         XwVSSkvwm/iMnA7Y4q4fCHuUo66n/GCzkb/o8=
MIME-Version: 1.0
In-Reply-To: <20101014213709.GD9250@vigoh>
References: <AANLkTi=CNW1pu-YdvmViqHxfw-_TDzvLkj15Ai_aANWo@mail.gmail.com>
	<20101014213709.GD9250@vigoh>
Date: Fri, 15 Oct 2010 11:54:02 -0400
Message-ID: <AANLkTi=xxj81e__fH1Bh8KuL_rmHVi0=ia9ELPUMThr-@mail.gmail.com>
Subject: Re: [PATCH] fix oops in l2cap_connect_req
From: Nathan Holstein <nathan.holstein@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 5:37 PM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
> Hi Nathan,
>
> * Nathan Holstein <nathan.holstein@gmail.com> [2010-10-14 18:37:53 -0400]:
>
>> (Please keep me in the CC list, I'm not subscribed to lkml)
>>
>> [1] L2CAP module dereferences an uninitialized pointer within l2cap_connect_req.
>>
>> [2] I'm currently testing a 2.6.35 kernel on a Nexus One with backported
>> patches from bluetooth-2.6.  When testing against certain BT devices, I'm seeing
>> a null-pointer deref.  The crash is caused by this portion of commit e9aeb2dd:
>>
>> @@ -2966,6 +2991,15 @@ sendresp:
>>                                         L2CAP_INFO_REQ, sizeof(info), &info);
>>         }
>>
>> +       if (!(l2cap_pi(sk)->conf_state & L2CAP_CONF_REQ_SENT) &&
>> +                               result == L2CAP_CR_SUCCESS) {
>> +               u8 buf[128];
>> +               l2cap_pi(sk)->conf_state |= L2CAP_CONF_REQ_SENT;
>> +               l2cap_send_cmd(conn, l2cap_get_ident(conn), L2CAP_CONF_REQ,
>> +                                       l2cap_build_conf_req(sk, buf), buf);
>> +               l2cap_pi(sk)->num_conf_req++;
>> +       }
>> +
>>         return 0;
>>  }
>>
>> Multiple error cases jump to the response & sendresp labels prior to
>> initializing
>> the "sk" variable.  In the case I'm currently seeing, the remote BT
>> device fails to
>> properly secure the ACL, making this crash 100% reproducible.
>>
>> [3] Bluetooth, L2CAP
>>
>> [4] This bug appears to be in the mainline 2.6.36-rc? kernel, in addition to
>>  multiple Bluetooth development trees
>>
>> The following patch fixes the crash.
>>
>>
>>    --nathan
>>
>> ---
>> In error cases when the ACL is insecure or we fail to allocate a new
>> struct sock, we jump to the "response" label.  If so, "sk" will be
>> uninitialized and the kernel crashes.
>>
>> Signed-off-by: Nathan Holstein <nathan.holstein@gmail.com>
>> ---
>>  net/bluetooth/l2cap.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
>> index d527b10..10ae0af 100644
>> --- a/net/bluetooth/l2cap.c
>> +++ b/net/bluetooth/l2cap.c
>> @@ -2911,7 +2911,7 @@ static inline int l2cap_connect_req(struct
>> l2cap_conn *conn, struct l2cap_cmd_hd
>>       struct l2cap_chan_list *list = &conn->chan_list;
>>       struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
>>       struct l2cap_conn_rsp rsp;
>> -     struct sock *parent, *uninitialized_var(sk);
>> +     struct sock *parent, *sk = 0;
>
> Your fix is right, but please make *sk = NULL here.
> When I wrote that code I thought is was a false positive, but no, it's
> bug. :(

Updated patch below.

> --
> Gustavo F. Padovan
> ProFUSION embedded systems - http://profusion.mobi
>

---
In error cases when the ACL is insecure or we fail to allocate a new
struct sock, we jump to the "response" label.  If so, "sk" will be
null and the kernel crashes.

Signed-off-by: Nathan Holstein <nathan.holstein@gmail.com>
---
 net/bluetooth/l2cap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 4ded76e..4a4aa63 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -2911,7 +2911,7 @@ static inline int l2cap_connect_req(struct
l2cap_conn *conn, struct l2cap_cmd_hd
 	struct l2cap_chan_list *list = &conn->chan_list;
 	struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
 	struct l2cap_conn_rsp rsp;
-	struct sock *parent, *uninitialized_var(sk);
+	struct sock *parent, *sk = NULL;
 	int result, status = L2CAP_CS_NO_INFO;

 	u16 dcid = 0, scid = __le16_to_cpu(req->scid);
@@ -3024,7 +3024,7 @@ sendresp:
 					L2CAP_INFO_REQ, sizeof(info), &info);
 	}

-	if (!(l2cap_pi(sk)->conf_state & L2CAP_CONF_REQ_SENT) &&
+	if (sk && !(l2cap_pi(sk)->conf_state & L2CAP_CONF_REQ_SENT) &&
 				result == L2CAP_CR_SUCCESS) {
 		u8 buf[128];
 		l2cap_pi(sk)->conf_state |= L2CAP_CONF_REQ_SENT;
-- 
1.7.2.3
