Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0HaMOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:14:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0HaMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w8Gi795oHmC9LqSXk9SpNrpNu+/FP1INqR5FJFCW0miWVsm0N/F+GObTeSdjYzOVwO
         IW/PcE5kLKZQeDHRkhUyKTqOsEIou8xCJ5KYbwNQFsBsriaCH4qccaEmipuuyMjO2y9Q
         KdgdcYjDGAuHWllGNlFOcvWNrE+4d6X5ZC7yo=
Subject: Re: vhost_dev_cleanup() crash: BUG: unable to handle kernel NULL
 pointer dereference
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>
In-Reply-To: <20100831111413.GB12853@elte.hu>
References: <20100831075705.GA4710@elte.hu>
	 <1283251801.2550.53.camel@edumazet-laptop> <20100831111413.GB12853@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 14:05:57 +0200
Message-ID: <1283256357.2550.61.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 août 2010 à 13:14 +0200, Ingo Molnar a écrit :
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > 
> > Seems to be commit c23f3445e68e1
> > (vhost: replace vhost_workqueue with per-vhost kthread)
> > 
> > following patch should cure it ?
> > 
> > Thanks
> > 
> > [PATCH] vhost: stop worker only if created
> > 
> > Its illegal to call kthread_stop(NULL)
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index e05557d..0a00121 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -323,7 +323,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  	dev->mm = NULL;
> >  
> >  	WARN_ON(!list_empty(&dev->work_list));
> > -	kthread_stop(dev->worker);
> > +	if (dev->worker)
> > +		kthread_stop(dev->worker);
> 
> Btw., i think this check should be pushed into kthread_stop() instead - 
> just like kfree(NULL) is possible as well - it simplifies cleanup 
> sequences.
> 

Sure !

Just in case, I resubmit the patch, clearing dev->worker, because I am
not sure if vhost_dev_cleanup() can be run several times on same struct
vhost_dev. Patch is needed even if you add this check in kthread_stop()

[PATCH v2] vhost: stop worker only if created

Its currently illegal to call kthread_stop(NULL)

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/vhost/vhost.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e05557d..4b99117 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -323,7 +323,10 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->mm = NULL;
 
 	WARN_ON(!list_empty(&dev->work_list));
-	kthread_stop(dev->worker);
+	if (dev->worker) {
+		kthread_stop(dev->worker);
+		dev->worker = NULL;
+	}
 }
 
 static int log_access_ok(void __user *log_base, u64 addr, unsigned long sz)


