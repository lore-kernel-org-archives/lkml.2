Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0JOTf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:35:26 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41432 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0JOTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:35:25 -0400
Subject: Re: [PATCH] fix oops in l2cap_connect_req
From: Marcel Holtmann <marcel@holtmann.org>
To: Nathan Holstein <nathan.holstein@gmail.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <AANLkTi=xxj81e__fH1Bh8KuL_rmHVi0=ia9ELPUMThr-@mail.gmail.com>
References: <AANLkTi=CNW1pu-YdvmViqHxfw-_TDzvLkj15Ai_aANWo@mail.gmail.com>
	 <20101014213709.GD9250@vigoh>
	 <AANLkTi=xxj81e__fH1Bh8KuL_rmHVi0=ia9ELPUMThr-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 22:35:20 +0300
Message-ID: <1287171320.3316.62.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

> > * Nathan Holstein <nathan.holstein@gmail.com> [2010-10-14 18:37:53 -0400]:
> >
> >> (Please keep me in the CC list, I'm not subscribed to lkml)
> >>
> >> [1] L2CAP module dereferences an uninitialized pointer within l2cap_connect_req.
> >>
> >> [2] I'm currently testing a 2.6.35 kernel on a Nexus One with backported
> >> patches from bluetooth-2.6.  When testing against certain BT devices, I'm seeing
> >> a null-pointer deref.  The crash is caused by this portion of commit e9aeb2dd:
> >>
> >> @@ -2966,6 +2991,15 @@ sendresp:
> >>                                         L2CAP_INFO_REQ, sizeof(info), &info);
> >>         }
> >>
> >> +       if (!(l2cap_pi(sk)->conf_state & L2CAP_CONF_REQ_SENT) &&
> >> +                               result == L2CAP_CR_SUCCESS) {
> >> +               u8 buf[128];
> >> +               l2cap_pi(sk)->conf_state |= L2CAP_CONF_REQ_SENT;
> >> +               l2cap_send_cmd(conn, l2cap_get_ident(conn), L2CAP_CONF_REQ,
> >> +                                       l2cap_build_conf_req(sk, buf), buf);
> >> +               l2cap_pi(sk)->num_conf_req++;
> >> +       }
> >> +
> >>         return 0;
> >>  }
> >>
> >> Multiple error cases jump to the response & sendresp labels prior to
> >> initializing
> >> the "sk" variable.  In the case I'm currently seeing, the remote BT
> >> device fails to
> >> properly secure the ACL, making this crash 100% reproducible.
> >>
> >> [3] Bluetooth, L2CAP
> >>
> >> [4] This bug appears to be in the mainline 2.6.36-rc? kernel, in addition to
> >>  multiple Bluetooth development trees
> >>
> >> The following patch fixes the crash.
> >>
> >>
> >>    --nathan

please send new patches with [PATCH v2] prefix to make it easier for
Gustavo to keep track.

> >> In error cases when the ACL is insecure or we fail to allocate a new
> >> struct sock, we jump to the "response" label.  If so, "sk" will be
> >> uninitialized and the kernel crashes.
> >>
> >> Signed-off-by: Nathan Holstein <nathan.holstein@gmail.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


