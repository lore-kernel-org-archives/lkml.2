Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1KYRAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:00:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54818 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1KYRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:00:07 -0500
Message-ID: <4ECFC992.6020706@gmail.com>
Date: Fri, 25 Nov 2011 09:00:02 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: spamm of cfg80211: Calling CRDA to update world regulatory domain
References: <4EB00DD3.7090701@gmail.com> <4ECFAAC2.9070005@01019freenet.de>
In-Reply-To: <4ECFAAC2.9070005@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 06:48 AM, Andreas Hartmann wrote:
> Hi,
>
> Justin P. Mattock schrieb:
>> is there a way to get rid of this annoying spamming of the regulatory?
>>
>>
>> [  338.519037] cfg80211: Calling CRDA to update world regulatory domain
>> [  338.523266] cfg80211: World regulatory domain updated:
>> [  338.523269] cfg80211:     (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [  338.523272] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [  338.523276] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
>> (300 mBi, 2000 mBm)
>> [  338.523279] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
>> (300 mBi, 2000 mBm)
>> [  338.523281] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [  338.523284] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>
> I can see these messages with compat-wireless-2011-11-22, two. They are
> sent out every 3 or 4 seconds. compat-wireless-2011-10-31 doesn't show
> the problem.
>
>
> Andreas
>


yep! usually if I go to starbucks to do things this message shows 
up(think most public areas I get this a lot).
if I connect to a home router this does not spamm the syslog that 
much(still does, just not as easily).
attached is dmesg of syslog at starbucks, within 10mins I already have 
like 3/4 of this..

http://fpaste.org/xzaz/

looking through the kernel I see mixed areas in of which this is 
triggered..:



net/wireless/reg.c:381

static int call_crda(const char *alpha2)
{
     if (!is_world_regdom((char *) alpha2))
         pr_info("Calling CRDA for country: %c%c\n",
             alpha2[0], alpha2[1]);
     else
         pr_info("Calling CRDA to update world regulatory domain\n");

     /* query internal regulatory database (if it exists) */
     reg_regdb_query(alpha2);

     return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
}


net/mac80211/work.c:498:

static enum work_action __must_check
ieee80211_authenticate(struct ieee80211_work *wk)
{

<----- lots of code --------->

     printk(KERN_DEBUG "%s: authenticate with %pM (try %d)\n",
            sdata->name, wk->filter_ta, wk->probe_auth.tries);


now not sure how this mechanism works, but there are _two_ approaches 
for the regulatory domain:

1) have the kernel use something like alpha2 that automatically 
finds/search _query's_ for the country or something.
or
2) manually add your country to net/wireless/db.txt with the country 
causing alpha1 to be used, which I think causes the kernel to not query 
for CRDA.

NOTE: I only spent a little time reading up on this, and trying it out 
so I might have got this wrong. all of this is on
http://linuxwireless.org/en/developers/Regulatory

Justin P. Mattock


