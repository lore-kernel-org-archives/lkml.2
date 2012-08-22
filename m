Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2HVL5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:57:49 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:41255 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab2HVL5q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:57:46 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 22 Aug 2012 13:57:32 +0200
Subject: RE: [PATCH 2/3] remoteproc: recover a remoteproc when it has crashed
Thread-Topic: [PATCH 2/3] remoteproc: recover a remoteproc when it has
 crashed
Thread-Index: Ac1/FLHtyBUB6PTUQyC2Kk8iMKW4SwAjaADw
Message-ID: <81C3A93C17462B4BBD7E272753C1057923B95AC7F0@EXDCVYMBSTM005.EQ1STM.local>
References: <CAJK669YTW7Uxm3HtT2ZKoZ6ScTWgc8F9jL8uHqn4p676iw_z-Q@mail.gmail.com>
 <CACY--9EWSRWu9sxq62rmOwNR0tzzr-1HEwH4gnWd4z0xtrAKpw@mail.gmail.com>
In-Reply-To: <CACY--9EWSRWu9sxq62rmOwNR0tzzr-1HEwH4gnWd4z0xtrAKpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

> > I think you drop the driver module's ref count during recovery, because
> > rproc_shutdown calls module_put(). Maybe you should move driver
> > ref count handling to rproc_add and rproc_type_release, instead of
> > rproc_boot() and rproc_shutdown()?
> 
> How could you remove the remoteproc modules then?
...
> At this point we have a circular dependency, omap_remoteproc depends on
> remoteproc and vice-versa. Making impossible to remove the remoteproc
> modules. So, I don't think it is a good idea to move module_get/put
> calls.

Yes, I see - you're right. What I proposed won't work.

> However, if you still have concerns about that or a valid testcase where
> that would have an unexpected behaviour we can think in a way to fix it.
> Probably just calling module_get/put inside  rproc_trigger_recover is
> the easiest way. Please let me know what you think.

My concern was unloading of pdev or driver modules durng async firmware
loading. However it turns out that my issue was that I was using
rproc_put() instead of rproc_del() when unloading my driver module.
So after fixing my driver your patch works fine even when unloading the
driver during firmware loading.

> > >+int rproc_trigger_recover(struct rproc *rproc)
> > >+{
> > >+      struct rproc_vdev *rvdev, *rvtmp;
> > >+
> > >+      dev_err(&rproc->dev, "recovering %s\n", rproc->name);
> > >+
> > >+      /* clean up remote vdev entries */
> > >+      list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node)
> > >+              rproc_remove_virtio_dev(rvdev);
> > ...
> > Is this safe? Are you guaranteed that rproc->power
> > is counted down to zero at this point.
...
> > I think you should wait for the rproc->power count to go to zero
> > before initiating the firmware_loading. You could e.g.
> > move firmware_loading to rproc_shutdown(), or add a
> > completion.
> 
> Yes, that sounds good and it will work when we supports
> rproc_boot/shutdown > calls from anywhere and not only from
> rpmsg module(find_vqs). Also, I think with that wait_for_completion
> inside rproc_trigger_recover will make more clear how the recovery
> is performed (actually the need for ref counter to
> become 0 in order to work).
> 
> I will try that and send a new patch to get more comments.


Ok, looking forward to your next patch then.

Regards,
Sjur
