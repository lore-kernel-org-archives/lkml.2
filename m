Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762351Ab2FVPXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:23:33 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49900 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762276Ab2FVPXb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Jun 2012 11:23:31 -0400
Message-Id: <4FE4AA3C020000780008B763@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 16:24:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kay Sievers" <kay@vrfy.org>
Cc: <yuanhan.liu@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: printk behavioral regression
References: <4FE09AFC020000780008A9DC@nat28.tlf.novell.com>
 <CAPXgP13y_xOUzHdStsDWescPtJYn0nvMhsQ7c2XS3HBuE=jwow@mail.gmail.com>
 <4FE0A30C020000780008AA0B@nat28.tlf.novell.com>
 <CAPXgP13F5dVRzW3wDLM4dCOJ=9+fztUHsBLXkV=shJ=KkDqT=g@mail.gmail.com>
In-Reply-To: <CAPXgP13F5dVRzW3wDLM4dCOJ=9+fztUHsBLXkV=shJ=KkDqT=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.06.12 at 16:34, Kay Sievers <kay@vrfy.org> wrote:
> On Tue, Jun 19, 2012 at 4:04 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>>> On 19.06.12 at 15:53, Kay Sievers <kay@vrfy.org> wrote:
>>> On Tue, Jun 19, 2012 at 3:30 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> running 3.5-rc3 on a SLE11 SP1 system, early boot messages (apart
>>>> from the very first one) end up in /var/log/messages rather than
>>>> /var/log/boot.msg. I didn't dig deep enough yet to figure out what
>>>> is causing this, and would hope that you (having contributed most
>>>> of the changes between 3.4 and 3.5-rc3) might have an idea.
>>>
>>> Hmm, no idea really, and why this should change.
>>
>> Okay, then I'll indeed need to do some debugging.
>>
>>> /var/log/boot.msg is a SUSE speciality, that, as far as I know, just
>>> dumps 'dmesg' after bootup, it has not much to do with the normal
>>> syslog/klog logging in /var/log/messages, where all your messages should
>>> always end up, and what seems to work for you.
> 
> Sure? The /var/log/boot.msg gets overwritten with every reboot, I
> don't remember losing all bootup messages in syslog on SUSE; and that
> would seriously weird if it behaves like that.
> 
>> No, boot messages (at least by default) end up _only_ in
>> /var/log/boot.msg, and thus significantly help keeping the size
>> of /var/log/messages down. SUSE specialty or not, there
>> clearly is some user space visible change here.
> 
> Look out for the SUSE tool blogd and how that is involved in getting
> these messages from the kernel.

The new code made SYSLOG_ACTION_READ return just a single
message, whereas the old implementation filled the buffer as far
as data was available. I'll send a patch in a minute.

> And there is a fix pending in Greg's tree:
>   
> http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commit;h=4 
> a77a5a06ec66ed05199b301e7c25f42f979afdc
> 
> which is supposed to fix a different issue, but we can never know ...

It does, yet I believe the fix I'm going to send addresses this as
well, in a more natural way. So I'd suggest considering reverting
that one.

Furthermore, the other fix from Yuanhan seems wrong to me
altogether: It causes the message that didn't fit to not be
reported anywhere (as syslog_req and syslog_idx already got
bumped). The issue that was attempted to be addressed there
will as well be addressed in a different way in the forthcoming
patch.

Jan

