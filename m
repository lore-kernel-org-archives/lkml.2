Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1AKEtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:49:11 -0500
Received: from tarap.cc.columbia.edu ([128.59.29.7]:65287 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1AKEtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:49:07 -0500
X-Greylist: delayed 1602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 23:49:07 EST
Message-ID: <4D2BDAF4.9040908@cs.columbia.edu>
Date: Mon, 10 Jan 2011 23:22:12 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Bastian Blank <bastian@waldi.eu.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
References: <20110110211135.GA22446@mail.hallyn.com>	<20110110211334.GD22564@mail.hallyn.com>	<20110110215240.GA21351@wavehammer.waldi.eu.org> <20110110225151.GA18944@localhost>
In-Reply-To: <20110110225151.GA18944@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/10/2011 05:51 PM, Serge Hallyn wrote:
> Quoting Bastian Blank (bastian@waldi.eu.org):
>> On Mon, Jan 10, 2011 at 09:13:34PM +0000, Serge E. Hallyn wrote:
>>> +	const struct cred *cred = current_cred();
>>> +	const struct cred *tcred = __task_cred(t);
>>> +
>>> +	if (cred->user->user_ns != tcred->user->user_ns) {
>>> +		/* userids are not equivalent - either you have the
>>> +		   capability to the target user ns or you don't */
>>> +		if (ns_capable(tcred->user->user_ns, CAP_KILL))
>>> +			return 1;
>>> +		return 0;
>>> +	}
>>> +
>>> +	/* same user namespace - usual credentials checks apply */
>>> +	if ((cred->euid ^ tcred->suid) &&
>>> +	    (cred->euid ^ tcred->uid) &&
>>> +	    (cred->uid  ^ tcred->suid) &&
>>> +	    (cred->uid  ^ tcred->uid) &&
>>> +	    !ns_capable(tcred->user->user_ns, CAP_KILL))
>>> +		return 0;
>>> +
>>> +	return 1;
>>
>> Isn't that equal to this?
>>
>> 	if (ns_capable(tcred->user->user_ns, CAP_KILL))
>> 		return 1;
>>
>> 	if (cred->user->user_ns == tcred->user->user_ns &&
>> 	    (cred->euid == tcred->suid ||
>> 	     cred->euid == tcred->uid ||
>> 	     cred->uid == tcred->suid ||
>> 	     cred->uid == tcred->uid))
>> 		return 1;
>>
>> 	return 0;
>>
>> I would consider this much easier to read.
> 
> Unfortunately, it's actually not equivalent.  when capable()
> returns success, then it sets the current->flags |= PF_SUPERPRIV.
> If permission is granted based on userids and the capability
> isn't needed, then we don't want to needlessly set PF_SUPERPRIV.

A bit off-topic: does this means that c/r needs to save and 
restore this process flag ?
> 
> That's why I'm going to such lengths to call capable() as a last
> resort.

IMHO, worth a one line comment in the code ...

Oren.
