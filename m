Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1GSS63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:58:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58044 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1GSS61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:58:27 -0400
MIME-Version: 1.0
X-Originating-IP: [192.91.66.189]
In-Reply-To: <20110716.131733.1746593505234880481.davem@davemloft.net>
References: <CABBYNZ+fxUWhi0uF0b_6Z8iqYd7Pp_4zPBRyM6Gyh3zJH1am5Q@mail.gmail.com>
	<201107150728.04355.edt@aei.ca>
	<alpine.LRH.2.00.1107162141340.7178@twin.jikos.cz>
	<20110716.131733.1746593505234880481.davem@davemloft.net>
Date: Tue, 19 Jul 2011 13:58:26 -0500
Message-ID: <CABUK1agxh+YWa462m98Sti0pkH0cGa23Lfmm_tcGjUeR5+XHNA@mail.gmail.com>
Subject: Re: [BUG] Bluetooth broken post rc7
From: Pavan Savoy <pavan_savoy@sify.com>
To: David Miller <davem@davemloft.net>
Cc: jkosina@suse.cz, edt@aei.ca, luiz.dentz@gmail.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        padovan@profusion.mobi, iliak@ti.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 3:17 PM, David Miller <davem@davemloft.net> wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Sat, 16 Jul 2011 21:43:06 +0200 (CEST)
>
>> could you please repost the patch with proper changelog and your
>> Signed-off-by, so that it could (hopefully) be applied for 3.0 still?
>
> It's already in my networking tree and on the way to Linus, and has
> been so for half a day.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I can't seem to get BNEP working, and I have a feeling it has got to
do something with this patch.
I actually hit the error condition NULL @ [ 8882.843017] chan->scid 64
[ 8882.845977] Bluetooth: parent is NULL
[ 8882.850067] conn e53e5e00, code 0x03, ident 0x66, len 8
[ 8882.855895] code 0x03
[ 8882.858581] hci0: type 2 len 21

which is at +//
parent->sk_data_ready(parent, 0);
+                                       if (parent) {
+                                               BT_ERR("hitting condition @\
+                                               %d", __LINE__);
+                                               parent->sk_data_ready(parent,
+                                               0);
+                                       } else {
+                                               BT_ERR("parent is NULL");
+                                       }

my l2cap_config_req does say this now,
@@ -2524,7 +2525,7 @@ static inline int l2cap_config_req(struct
l2cap_conn *conn, struct l2cap_cmd_hdr

        sk = chan->sk;

-       if (chan->state != BT_CONFIG) {
+       if (chan->state != BT_CONFIG && sk->sk_state != BT_CONNECT2) {
                struct l2cap_cmd_rej rej;


However, I can seem to connect because of the following reason,
[ 8887.914703] l2cap_chan_timeout: reason: 110
[ 8887.919342] chan e26fc800 state 6 socket cfc38a00
[ 8887.924560] conn e53e5e00, code 0x03, ident 0x66, len 8
[ 8887.930328] code 0x03
[ 8887.932830] chan e26fc800 state 8
[ 8887.936614] chan e26fc800, conn e53e5e00, err 110
[ 8887.941925] hci0: type 2 len 21
[ 8891.047576] hcon d44c7000 reason 19
[ 8891.051666] hcon d44c7000 conn e53e5e00, err 104
[ 8942.897979] chan e26fc800 state 9 socket cfc38a00


Any suggestions ??
