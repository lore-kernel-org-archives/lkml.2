Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0IBMGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:06:36 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:38585 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752461Ab0IBMGe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 08:06:34 -0400
MIME-Version: 1.0
In-Reply-To: <4C7F6E26.2030301@gmail.com>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
	<1283306184-28833-2-git-send-email-chase.douglas@canonical.com>
	<4C7E94F6.9050806@gmail.com>
	<AANLkTi=z5s8mbjG54930Lxj-O9Of2fXHE6kDJhijyOb7@mail.gmail.com>
	<4C7F6E26.2030301@gmail.com>
Date: Thu, 2 Sep 2010 08:06:32 -0400
Message-ID: <AANLkTikb=eNzek-vQ=d3jZxitsbtJ5gD6BNDipAUpUcJ@mail.gmail.com>
Subject: Re: [PATCH 1/7 v3] HID: magicmouse: don't allow hidinput to
 initialize the device
From: Michael Poole <mdpoole@troilus.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 5:28 AM, Jiri Slaby wrote:
> On 09/02/2010 01:57 AM, Michael Poole wrote:
>> Jiri Slaby wrote:
>>> This looks weird. Is there any past discussion about why you cannot use
>>> hidinput and you have to do all the input bits yourself while cheating
>>> this very weird way?
>>
>> The Magic Mouse and Magic Trackpad do not publish HID descriptors for
>> the multitouch reports.  Given the variable-length report packets --
>> and especially the Magic Trackpad's new, mutant DOUBLE_REPORT_ID
>> packets -- it would be non-trivial to write accurate descriptors that
>> the HID core can use.  (Someone wrote a patch to try that a few months
>> ago.  It ended up adding significantly more lines to hid-magicmouse.c
>> than it removed, and it was not obvious to me that it got the Report
>> Count fields correct.)
>
> Ok, makes sense. The proper solution is to call a driver hook in
> hidinput_connect to do the mapping instead of report parsing done there,
> right? (And not setting [gs]etkeycode in that case.)

I do not know how this would work with the current HID core; could you
elaborate?  For the Magic Mouse, there is a valid descriptor for the
0x10 (traditional mouse motion and clicks) report, and a pretty
trivial descriptor in the vendor-defined usage region (which I assume
Apple drivers use to identify the ensemble of multi-touch,
mouse-up/down, laser status and battery level reports).  How would the
driver's input_mapping() hook, or any other hook, map that single
descriptor into fields for each of the parts of a multi-touch report,
or support the other reports?  How would hid-magicmouse describe the
report so that hid-core handles the variable-length multi-touch
reports properly?  As far as I can tell, hid_report_raw_event() and
its callees assume each report has fixed length.

> Then the part of magicmouse_setup_input starting at the first __set_bit
> will be exactly the hook.
>
> Otherwise this hack looks like a hard cross-layer breakage.
>
> /me wonders how HID issuers are creative in breaking standards.

In Apple's case, apparently fairly creative.  Devices from other
sources seem to generate one report per touch, rather than cram as
many touches as possible into a single report.

Michael Poole
