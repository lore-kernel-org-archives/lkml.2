Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0LQVfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:35:44 -0500
Received: from smtp-out.google.com ([74.125.121.67]:33828 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab0LQVfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:35:41 -0500
X-Greylist: delayed 887 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2010 16:35:40 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pE5MIjF8cDND7WFcCSgFNvOXjEcaJCVcVkDUvGhIxxSJU2+WoPL5CbFtRBaejE9675
         WKEXjgiuk+vSZwZ5gsYQ==
MIME-Version: 1.0
In-Reply-To: <20101217205238.GA8642@hmsreliant.think-freely.org>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
 <20101214212909.17022.96801.stgit@mike.mtv.corp.google.com> <20101217205238.GA8642@hmsreliant.think-freely.org>
From: Mike Waychison <mikew@google.com>
Date: Fri, 17 Dec 2010 13:20:30 -0800
Message-ID: <AANLkTikG-XepYDb3R9=T8NP5TWVgsKNK-QmXrznGDHUO@mail.gmail.com>
Subject: Re: [PATCH v3 03/22] netconsole: Introduce 'enabled' state-machine
To: Neil Horman <nhorman@tuxdriver.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 12:52 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Dec 14, 2010 at 01:29:10PM -0800, Mike Waychison wrote:

>> @@ -680,16 +699,17 @@ static int netconsole_netdev_event(struct notifier_block *this,
>>       struct net_device *dev = ptr;
>>
>>       if (!(event == NETDEV_CHANGENAME || event == NETDEV_UNREGISTER ||
>> -           event == NETDEV_BONDING_DESLAVE || event == NETDEV_GOING_DOWN))
>> +           event == NETDEV_BONDING_DESLAVE))
>>               goto done;
>>
>>       spin_lock_irqsave(&target_list_lock, flags);
>>       list_for_each_entry(nt, &target_list, list) {
>> -             if (nt->np.dev == dev) {
>> +             if (nt->np_state == NETPOLL_ENABLED && nt->np.dev == dev) {
>>                       switch (event) {
>>                       case NETDEV_CHANGENAME:
>>                               strlcpy(nt->np.dev_name, dev->name, IFNAMSIZ);
>>                               break;
>> +                     case NETDEV_BONDING_DESLAVE:
>>                       case NETDEV_UNREGISTER:
> I don't follow what you're doing here.  Previously NETDEV_BONDING_DESLAVE events
> simply caused the netconsole interface to get deactivated, and now we're doing a
> dev_put on the bonded interface bacause of the above move.  Given that
> NETDEV_BONDING_DESLAVE events are generated when a slave leaves the bond, this
> doesn't seem right, or am I missing something

Ya, I did a poor job of explaining this bit.  Let me try now:

- NETDEV_GOING_DOWN is unneccesary because we will always see a
NETDEV_UNREGISTER event, which is why it is removed.
- I wasn't sure how to handle the NETDEV_BONDING_DESLAVE event in a
consistent way.  Originally we would disable the target, but this
actually leaks nt->np as it will never get cleaned up properly.  To
the user, it looks as if the target gets disabled.

I don't think you have any contention with the first comment above
(though I need to document it).

You are right in that with this patch, the target is left enabled,
when we should probably mark it as disabled.  I'd be happy to add the
transition from NETPOLL_ENABLED -> NETPOLL_DISABLED here if you'd
like, but it'd move again in the next patch anyway (which already
re-introduces the state transition in defer_netpoll_cleanup()).  Sorry
this is confusing :(   I'll make it clearer in the next series
version.
