Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0IDBKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:10:45 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60020 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752057Ab0IDBKn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <4C80DB38.9040101@gmail.com>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
	<1283306184-28833-2-git-send-email-chase.douglas@canonical.com>
	<4C7E94F6.9050806@gmail.com>
	<AANLkTi=z5s8mbjG54930Lxj-O9Of2fXHE6kDJhijyOb7@mail.gmail.com>
	<4C7F6E26.2030301@gmail.com>
	<AANLkTikb=eNzek-vQ=d3jZxitsbtJ5gD6BNDipAUpUcJ@mail.gmail.com>
	<4C80DB38.9040101@gmail.com>
Date: Fri, 3 Sep 2010 21:10:41 -0400
Message-ID: <AANLkTi=xeHUV2s8Tu3tF2A8hODML68MYpH4_7j1z-t0a@mail.gmail.com>
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

On Fri, Sep 3, 2010 at 7:25 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/02/2010 02:06 PM, Michael Poole wrote:
>> On Thu, Sep 2, 2010 at 5:28 AM, Jiri Slaby wrote:
>>> On 09/02/2010 01:57 AM, Michael Poole wrote:
>>>> Jiri Slaby wrote:
>>>>> This looks weird. Is there any past discussion about why you cannot use
>>>>> hidinput and you have to do all the input bits yourself while cheating
>>>>> this very weird way?
>>>>
>>>> The Magic Mouse and Magic Trackpad do not publish HID descriptors for
>>>> the multitouch reports.  Given the variable-length report packets --
>>>> and especially the Magic Trackpad's new, mutant DOUBLE_REPORT_ID
>>>> packets -- it would be non-trivial to write accurate descriptors that
>>>> the HID core can use.  (Someone wrote a patch to try that a few months
>>>> ago.  It ended up adding significantly more lines to hid-magicmouse.c
>>>> than it removed, and it was not obvious to me that it got the Report
>>>> Count fields correct.)
>>>
>>> Ok, makes sense. The proper solution is to call a driver hook in
>>> hidinput_connect to do the mapping instead of report parsing done there,
>>> right? (And not setting [gs]etkeycode in that case.)
>>
>> I do not know how this would work with the current HID core; could you
>> elaborate?
>
> No way. You would have to implement that.
>
>>  For the Magic Mouse, there is a valid descriptor for the
>> 0x10 (traditional mouse motion and clicks) report, and a pretty
>> trivial descriptor in the vendor-defined usage region (which I assume
>> Apple drivers use to identify the ensemble of multi-touch,
>> mouse-up/down, laser status and battery level reports).  How would the
>> driver's input_mapping() hook, or any other hook, map that single
>> descriptor into fields for each of the parts of a multi-touch report,
>> or support the other reports?  How would hid-magicmouse describe the
>> report so that hid-core handles the variable-length multi-touch
>> reports properly?  As far as I can tell, hid_report_raw_event() and
>> its callees assume each report has fixed length.
>
> If I understand correctly, you have 2 reports. One report is standard
> HID and one is very specific and broken.
> 1) I don't understand where events from the standard report are going
> now while no output is claimed. In other words, why you return from
> raw_event in the default case 0, there is nobody to eat the data, right?

hid-magicmouse.c parses the standard-compliant report.  It is the
"case 0x10:" handler.

> 2) You handle events from the broken (or missing) report in
> magicmouse_raw_event and it will remain as is.
>
> So in the end there will be some .parse_reports hook called from inside
> hidinput_connect or somewhere instead of parsing and you will do the job
> you currently do in magicmouse_setup_input except the input structure
> setup (this will be done generically in hid core).
>
> The approach you have now is prone to errors, because somebody in the
> future may add a new claimant without bearing in mind to update these
> drivers.

What input_dev should this use for delivering events from the
non-standard report?  The only way I saw (or see) for hid-magicmouse
to get the (hid-input-created) input_dev for the mouse is to look at
hid_device->report_enum[HID_INPUT_REPORT].report_list to get a struct
hid_report*, then use hid_report->field[0]->hidinput->input.  That
seemed more fragile and abstraction-breaking than the existing
approach.

Right now, the device-specific driver's raw_event hook gets the first
shot at parsing any report; hid-core and hid-input process reports for
which raw_event returns 0.  If someone adds a new kind of claimant
that gets higher priority than both of those categories, by definition
it wouldn't be an error for it to supersede hid-magicmouse's handler.

Michael Poole
