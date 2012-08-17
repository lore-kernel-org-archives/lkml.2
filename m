Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab2HQJW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab2HQJWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:22:49 -0400
Message-ID: <502E0D9D.8070909@redhat.com>
Date: Fri, 17 Aug 2012 11:23:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>, Miklos Szeredi <miklos@szeredi.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
References: <Pine.LNX.4.44L0.1208161232001.31195-100000@netrider.rowland.org> <201208162202.40929.rjw@sisk.pl>
In-Reply-To: <201208162202.40929.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 08/16/2012 10:02 PM, Rafael J. Wysocki wrote:
> On Thursday, August 16, 2012, Alan Stern wrote:
>> On Thu, 16 Aug 2012, Miklos Szeredi wrote:
>>
>>> Yes, this appears to work.  Following patch fixes the suspend oops.
>>>
>>> Thanks,
>>> Miklos
>
> OK
>
> Miklos, can you please send that to Dave with a proper changelog and
> sign-off (please add my ACK too)?  Please make it clear that this is a
> regression fix and which commit has introduced the regression.

I think that Alan's suggest fix, as implemented by Milos is great!, but
before moving forward with this someone should audit all the other
(generic) ide code for other places using the drvdata, a simple grep
for dev_get_drvdata should show these.

<snip>

>> And now you can get rid of the useless dev_set_drvdata() call.
>
> That was in the other patch I think.

No my patch was a hack to undo the results of the commit causing
the regression in the IDE case. But Alan's approach clearly is
much better! Once we are sure drvdata is not used anywhere the
dev_set_drvdata call could be removed in the place where my
hack added a second call to it. Note that there are likely
actual ide drivers using it, without setting it themselves since
the ide core was setting it. So removing it will require even more
auditing / checking.

A 3th thing which should be audited is the generic ide code assuming
that dev->driver != NULL, this is at least true for
generic_ide_remove, where:

if (drv->remove)

Should be changed to:

if (dev->driver && drv->remove)

Following the way things are done in generic_ide_shutdown, a similar
change could be needed for generic_ide_probe(), although I guess
that may never get called with dev->driver == NULL ?

Unfortunately I'm very busy with other stuff atm, so I cannot help
here other then pointing out that such audits should be done :|

Regards,

Hans
