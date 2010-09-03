Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab0ICLZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:25:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab0ICLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=T4OclgskBZKTALHD4uJn4mJADe+njHSPwB4IdyopM4EyN5k6zVfXbpbXBQkX/F5llp
         SGQ6bPtFv8G083Bn3AUHaFSb+BpwD7puGgE7HlU1k1cY5AREw3Kyoh6TvAq6N5GPjWbU
         bcT3ghEEy9/EaTupv9mmv9hKUVu3V6GSlcXK4=
Message-ID: <4C80DB38.9040101@gmail.com>
Date: Fri, 03 Sep 2010 13:25:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Chase Douglas <chase.douglas@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7 v3] HID: magicmouse: don't allow hidinput to initialize
 the device
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>	<1283306184-28833-2-git-send-email-chase.douglas@canonical.com>	<4C7E94F6.9050806@gmail.com>	<AANLkTi=z5s8mbjG54930Lxj-O9Of2fXHE6kDJhijyOb7@mail.gmail.com>	<4C7F6E26.2030301@gmail.com> <AANLkTikb=eNzek-vQ=d3jZxitsbtJ5gD6BNDipAUpUcJ@mail.gmail.com>
In-Reply-To: <AANLkTikb=eNzek-vQ=d3jZxitsbtJ5gD6BNDipAUpUcJ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 02:06 PM, Michael Poole wrote:
> On Thu, Sep 2, 2010 at 5:28 AM, Jiri Slaby wrote:
>> On 09/02/2010 01:57 AM, Michael Poole wrote:
>>> Jiri Slaby wrote:
>>>> This looks weird. Is there any past discussion about why you cannot use
>>>> hidinput and you have to do all the input bits yourself while cheating
>>>> this very weird way?
>>>
>>> The Magic Mouse and Magic Trackpad do not publish HID descriptors for
>>> the multitouch reports.  Given the variable-length report packets --
>>> and especially the Magic Trackpad's new, mutant DOUBLE_REPORT_ID
>>> packets -- it would be non-trivial to write accurate descriptors that
>>> the HID core can use.  (Someone wrote a patch to try that a few months
>>> ago.  It ended up adding significantly more lines to hid-magicmouse.c
>>> than it removed, and it was not obvious to me that it got the Report
>>> Count fields correct.)
>>
>> Ok, makes sense. The proper solution is to call a driver hook in
>> hidinput_connect to do the mapping instead of report parsing done there,
>> right? (And not setting [gs]etkeycode in that case.)
> 
> I do not know how this would work with the current HID core; could you
> elaborate?

No way. You would have to implement that.

>  For the Magic Mouse, there is a valid descriptor for the
> 0x10 (traditional mouse motion and clicks) report, and a pretty
> trivial descriptor in the vendor-defined usage region (which I assume
> Apple drivers use to identify the ensemble of multi-touch,
> mouse-up/down, laser status and battery level reports).  How would the
> driver's input_mapping() hook, or any other hook, map that single
> descriptor into fields for each of the parts of a multi-touch report,
> or support the other reports?  How would hid-magicmouse describe the
> report so that hid-core handles the variable-length multi-touch
> reports properly?  As far as I can tell, hid_report_raw_event() and
> its callees assume each report has fixed length.

If I understand correctly, you have 2 reports. One report is standard
HID and one is very specific and broken.
1) I don't understand where events from the standard report are going
now while no output is claimed. In other words, why you return from
raw_event in the default case 0, there is nobody to eat the data, right?
2) You handle events from the broken (or missing) report in
magicmouse_raw_event and it will remain as is.


So in the end there will be some .parse_reports hook called from inside
hidinput_connect or somewhere instead of parsing and you will do the job
you currently do in magicmouse_setup_input except the input structure
setup (this will be done generically in hid core).

The approach you have now is prone to errors, because somebody in the
future may add a new claimant without bearing in mind to update these
drivers.

regards,
-- 
js
