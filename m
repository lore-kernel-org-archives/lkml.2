Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2EIJ6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:58:49 -0400
Received: from imr4.ericy.com ([198.24.6.9]:41313 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab2EIJ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:58:48 -0400
Date: Wed, 9 May 2012 02:56:17 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v4] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120509095617.GB15630@ericsson.com>
References: <1336474175-5714-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1336495180.22553.68.camel@groeck-laptop>
 <20120509070906.GA21556@otc-wbsnb-06>
 <20120509072339.GB21556@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120509072339.GB21556@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 03:23:39AM -0400, Kirill A. Shutemov wrote:
> On Wed, May 09, 2012 at 10:09:06AM +0300, Kirill A. Shutemov wrote:
> > On Tue, May 08, 2012 at 09:39:40AM -0700, Guenter Roeck wrote:
> > > On Tue, 2012-05-08 at 06:49 -0400, Kirill A. Shutemov wrote:
> > > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > 
> > > > Let's rework code to allow arbitrary number of cores on a CPU, not
> > > > limited by hardcoded array size.
> > > > 
> > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > ---
> > > >  v4:
> > > >    - address issues pointed by Guenter Roeck;
> > > >  v3:
> > > >    - drop redundant refcounting and checks;
> > > >  v2:
> > > >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> > > >    - use mutex instead of spinlock for list locking.
> > > > ---
> > > 
> > > Hi Kirill,
> > > 
> > > unfortunately now we have another race condition :(. See below ...
> > 
> > Ughh..
> > 
> > > > @@ -557,11 +579,22 @@ exit_free:
> > > >  static int __devexit coretemp_remove(struct platform_device *pdev)
> > > >  {
> > > >  	struct platform_data *pdata = platform_get_drvdata(pdev);
> > > > -	int i;
> > > > +	struct temp_data *tdata;
> > > >  
> > > > -	for (i = MAX_CORE_DATA - 1; i >= 0; --i)
> > > > -		if (pdata->core_data[i])
> > > > -			coretemp_remove_core(pdata, &pdev->dev, i);
> > > > +	for (;;) {
> > > > +		mutex_lock(&pdata->temp_data_lock);
> > > > +		if (!list_empty(&pdata->temp_data_list)) {
> > > > +			tdata = list_first_entry(&pdata->temp_data_list,
> > > > +					struct temp_data, list);
> > > > +			list_del(&tdata->list);
> > > > +		} else
> > > > +			tdata = NULL;
> > > > +		mutex_unlock(&pdata->temp_data_lock);
> > > > +
> > > > +		if (!tdata)
> > > > +			break;
> > > > +		coretemp_remove_core(tdata, &pdev->dev);
> > > > +	}
> > > >  
> > > Unfortunately, that results in a race condition, since the tdata list
> > > entry is gone before the attribute file is deleted.
> > > 
> > > I think you can still use list_for_each_entry_safe, only outside the
> > > mutex, and remove the list entry at the end of coretemp_remove_core()
> 
> I haven't got how list_for_each_entry_safe() will be really safe without
> the lock.
> 
We know that it by itself won't be called multiple times. So the only question is 
if the functions to add/remove a core can be called while coretemp_remove is called,
or if that is mutually exclusive (not that the current code handles this case).

Fortunately, there is a function to block CPU removal/insertion: get_online_cpus()
and put_online_cpus(). I have no idea if it is necessary to protect coretemp_remove()
with it, but it might be on the safe side anyway.

> > > after deleting the attribute file. Just keep the code as it was, and
> > > remove the list entry (mutex-protected) where core_data[] was set to
> > > NULL.
> > 
> > I think
> > 
> > if (tdata)
> > 	return -ENODEV;
> > 
> > in show methods will fix the issue. Right?
> 
> It won't. Stupid me.
> 
> But the check + kref seems will work...
> 
Yes, but would be way too complicated.

Guenter

