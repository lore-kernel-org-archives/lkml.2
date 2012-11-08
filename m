Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2KHBbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:31:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:7324 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab2KHBbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:31:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,735,1344236400"; 
   d="scan'208";a="165755946"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ming Lei <ming.lei@canonical.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] firmware loader: Fix the race FW_STATUS_DONE is
 followed by class_timeout
Thread-Topic: [PATCH] firmware loader: Fix the race FW_STATUS_DONE is
 followed by class_timeout
Thread-Index: AQHNvNQ/5SQqMoRScEiMffh0F5aH45ffJ6aA
Date: Thu, 8 Nov 2012 01:31:33 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1BFA76@SHSMSX101.ccr.corp.intel.com>
References: <1352306744.15558.1608.camel@cliu38-desktop-build>
 <CACVXFVOtbY8FX1GTsBR4R0W_R8UjHjjmGTTcKfqvNY5tX7h6OQ@mail.gmail.com>
In-Reply-To: <CACVXFVOtbY8FX1GTsBR4R0W_R8UjHjjmGTTcKfqvNY5tX7h6OQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ming Lei [mailto:ming.lei@canonical.com]
> Sent: Wednesday, November 07, 2012 6:40 PM
> To: Liu, Chuansheng
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] firmware loader: Fix the race FW_STATUS_DONE is
> followed by class_timeout
> 
> On Thu, Nov 8, 2012 at 12:45 AM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> >
> > There is a race condition as below when calling request_firmware():
> >
> > CPU1                                    CPU2
> > write 0 > loading
> > mutex_lock(&fw_lock);
> > ...
> > set_bit FW_STATUS_DONE                  class_timeout is coming
> >                                         set_bit
> FW_STATUS_ABORT
> > complete_all &completion
> > ...
> > mutex_unlock(&fw_lock)
> 
> Good catch, but your fix isn't correct.
> 
> >
> > In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
> > and request_firmware() will return failure due to condition in
> > _request_firmware_load():
> >
> >         if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
> >                 retval = -ENOENT;
> >
> > But from the above scenerio, it should be a succcessful requesting.
> > So we need judge if the FW_STATUS_DONE is set before calling abort
> > in timeout function firmware_class_timeout().
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/base/firmware_class.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 8945f4e..35fffd8 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -671,6 +671,13 @@ static void firmware_class_timeout(u_long data)
> >  {
> >         struct firmware_priv *fw_priv = (struct firmware_priv *) data;
> >
> > +       mutex_lock(&fw_lock);
> 
> mutex can't be used in interrupt context, so one candidate fix is
> to convert the timeout timer into delayed work, and hold the
> 'fw_lock' during the work function.
> 
> > +       if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
> > +               mutex_unlock(&fw_lock);
> > +               return;
> > +       }
> > +       mutex_unlock(&fw_lock);
> > +
> >         fw_load_abort(fw_priv);
> >  }
> 
> Also the lock of 'fw_lock' should be held when setting 'FW_STATUS_DONE'
> in _request_firmware_load().
> 
> Could you send out a new patch to fix the race?
Thanks your review and proposal, has sent the patch V2 to be reviewed.
> 
> Thanks,
> --
> Ming Lei
