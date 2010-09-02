Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0IBVCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:02:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0IBVCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A0KPqxak2SZr5CDaGdeVHKjGRf/Z0U53aEnVWWb2dCiQlBE20DrbVSFnsteGVMgPwO
         RgogEpqrdAeZM6Fkqt7A==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1009021642320.1311-100000@iolanthe.rowland.org>
References: <AANLkTi=s3_kFvRY9Afzku82gUgW7YKYXDBZvTkxQsMP8@mail.gmail.com>
	<Pine.LNX.4.44L0.1009021642320.1311-100000@iolanthe.rowland.org>
Date: Thu, 2 Sep 2010 14:01:32 -0700
X-Google-Sender-Auth: WTzTCUb1jZn-NKrHa4Pfo-cb3Jg
Message-ID: <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
From: Colin Cross <ccross@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 1:45 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 2 Sep 2010, Colin Cross wrote:
>
>> >> I think it would be better to change device_pm_init() and add a
>> >> complete_all().
>> >
>> > I agree.
>> That would work, and was my first solution, but it increases the
>> reliance on the completion variable being left completed between state
>> transitions, which is undocumented and unnecessary.  It seems more
>> straightforward to me to only wait on the parent if the parent is
>> suspended.
>
> How about calling complete_all() from within dpm_prepare() as well?
> Then it will get initialized properly at the beginning of every sleep
> transition.
That would work, but I still don't see why it's better.  With either
of your changes, the power.completion variable is storing state, and
not just used for notification.  However, the exact meaning of that
state is unclear, especially during the transition from an aborted
suspend to resume, and the state is duplicating power.status.  Setting
it to complete in dpm_prepare is especially confusing, because at that
point nothing is completed, it hasn't even been started.
