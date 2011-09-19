Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1ISLCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:02:01 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54476 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1ISLCA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:3:1>);
	Mon, 19 Sep 2011 07:02:00 -0400
Message-Id: <4E773D440200007800056A6D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 19 Sep 2011 12:01:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: [Xen-devel] Re: [PATCH] xen/pciback: Use mutexes when working
	 with Xenbus state transitions.
References: <20110916190601.GA31796@phenom.oracle.com>
 <4E7738E90200007800056A54@nat28.tlf.novell.com>
In-Reply-To: <4E7738E90200007800056A54@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.09.11 at 12:43, "Jan Beulich" <JBeulich@suse.com> wrote:
>>>> On 16.09.11 at 21:06, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
>> The caller that orchestrates the state changes is xenwatch_thread
>> and it takes a mutex. In our processing of Xenbus states we can take
>> the luxery of going to sleep on a mutex, so lets do that and
> 
> This is only the direct conversion of existing spinlock accesses in
> xenbus.c. However, in the course of converting from the legacy
> implementation you stripped a couple more (in xen_pcibk_attach(),
> xen_pcibk_reconfigure(), and xen_pcibk_setup_backend()), and

Actually, xen_pcibk_attach() has its lock taken in xen_pcibk_do_attach(),
so no change needed there.

In xen_pcibk_reconfigure() and xen_pcibk_setup_backend() the locking
may be redundant with the one in passthrough.c/vpci.c - is that the
basis upon which you removed the locks taken there?

Jan

> those should now get re-added imo.
> 
> Jan
> 
>> also fix this bug:
>> 
>> BUG: sleeping function called from invalid context at 
>> /linux/kernel/mutex.c:271
>> in_atomic(): 1, irqs_disabled(): 0, pid: 32, name: xenwatch
>> 2 locks held by xenwatch/32:
>>  #0:  (xenwatch_mutex){......}, at: [<ffffffff813856ab>] 
>> xenwatch_thread+0x4b/0x180
>>  #1:  (&(&pdev->dev_lock)->rlock){......}, at: [<ffffffff8138f05b>] 
>> xen_pcibk_disconnect+0x1b/0x80
>> Pid: 32, comm: xenwatch Not tainted 3.1.0-rc6-00015-g3ce340d #2
>> Call Trace:
>>  [<ffffffff810892b2>] __might_sleep+0x102/0x130
>>  [<ffffffff8163b90f>] mutex_lock_nested+0x2f/0x50
>>  [<ffffffff81382c1c>] unbind_from_irq+0x2c/0x1b0
>>  [<ffffffff8110da66>] ? free_irq+0x56/0xb0
>>  [<ffffffff81382dbc>] unbind_from_irqhandler+0x1c/0x30
>>  [<ffffffff8138f06b>] xen_pcibk_disconnect+0x2b/0x80
>>  [<ffffffff81390348>] xen_pcibk_frontend_changed+0xe8/0x140
>>  [<ffffffff81387ac2>] xenbus_otherend_changed+0xd2/0x150
>>  [<ffffffff810895c1>] ? get_parent_ip+0x11/0x50
>>  [<ffffffff81387de0>] frontend_changed+0x10/0x20
>>  [<ffffffff81385712>] xenwatch_thread+0xb2/0x180
>> 
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>  drivers/xen/xen-pciback/pciback.h |    2 +-
>>  drivers/xen/xen-pciback/xenbus.c  |   16 +++++-----------
>>  2 files changed, 6 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/xen/xen-pciback/pciback.h 
>> b/drivers/xen/xen-pciback/pciback.h
>> index a0e131a..c3af628 100644
>> --- a/drivers/xen/xen-pciback/pciback.h
>> +++ b/drivers/xen/xen-pciback/pciback.h
>> @@ -27,7 +27,7 @@ struct pci_dev_entry {
>>  
>>  struct xen_pcibk_device {
>>  	void *pci_dev_data;
>> -	spinlock_t dev_lock;
>> +	struct mutex dev_lock;
>>  	struct xenbus_device *xdev;
>>  	struct xenbus_watch be_watch;
>>  	u8 be_watching;
>> diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
>> index 978d2c6..c057d67 100644
>> --- a/drivers/xen/xen-pciback/xenbus.c
>> +++ b/drivers/xen/xen-pciback/xenbus.c
>> @@ -44,7 +44,7 @@ static struct xen_pcibk_device *alloc_pdev(struct 
>> xenbus_device *xdev)
>>  	pdev->xdev = xdev;
>>  	dev_set_drvdata(&xdev->dev, pdev);
>>  
>> -	spin_lock_init(&pdev->dev_lock);
>> +	mutex_init(&pdev->dev_lock);
>>  
>>  	pdev->sh_info = NULL;
>>  	pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
>> @@ -62,14 +62,13 @@ out:
>>  
>>  static void xen_pcibk_disconnect(struct xen_pcibk_device *pdev)
>>  {
>> -	spin_lock(&pdev->dev_lock);
>> +	mutex_lock(&pdev->dev_lock);
>>  
>>  	/* Ensure the guest can't trigger our handler before removing devices */
>>  	if (pdev->evtchn_irq != INVALID_EVTCHN_IRQ) {
>>  		unbind_from_irqhandler(pdev->evtchn_irq, pdev);
>>  		pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
>>  	}
>> -	spin_unlock(&pdev->dev_lock);
>>  
>>  	/* If the driver domain started an op, make sure we complete it
>>  	 * before releasing the shared memory */
>> @@ -77,13 +76,11 @@ static void xen_pcibk_disconnect(struct xen_pcibk_device 
>> *pdev)
>>  	/* Note, the workqueue does not use spinlocks at all.*/
>>  	flush_workqueue(xen_pcibk_wq);
>>  
>> -	spin_lock(&pdev->dev_lock);
>>  	if (pdev->sh_info != NULL) {
>>  		xenbus_unmap_ring_vfree(pdev->xdev, pdev->sh_info);
>>  		pdev->sh_info = NULL;
>>  	}
>> -	spin_unlock(&pdev->dev_lock);
>> -
>> +	mutex_unlock(&pdev->dev_lock);
>>  }
>>  
>>  static void free_pdev(struct xen_pcibk_device *pdev)
>> @@ -120,9 +117,8 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device 
>> *pdev, int gnt_ref,
>>  		goto out;
>>  	}
>>  
>> -	spin_lock(&pdev->dev_lock);
>> +	mutex_lock(&pdev->dev_lock);
>>  	pdev->sh_info = vaddr;
>> -	spin_unlock(&pdev->dev_lock);
>>  
>>  	err = bind_interdomain_evtchn_to_irqhandler(
>>  		pdev->xdev->otherend_id, remote_evtchn, xen_pcibk_handle_event,
>> @@ -132,14 +128,12 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device 
>> *pdev, int gnt_ref,
>>  				 "Error binding event channel to IRQ");
>>  		goto out;
>>  	}
>> -
>> -	spin_lock(&pdev->dev_lock);
>>  	pdev->evtchn_irq = err;
>> -	spin_unlock(&pdev->dev_lock);
>>  	err = 0;
>>  
>>  	dev_dbg(&pdev->xdev->dev, "Attached!\n");
>>  out:
>> +	mutex_unlock(&pdev->dev_lock);
>>  	return err;
>>  }
>>  
> 
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com 
> http://lists.xensource.com/xen-devel 


