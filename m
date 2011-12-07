Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab1LGO3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:29:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47414 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1LGO3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:29:20 -0500
Message-ID: <4EDF7812.3070506@polito.it>
Date: Wed, 07 Dec 2011 15:28:34 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, Kenneth Goldman <kgoldman@us.ibm.com>
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it> <1321450690.1901.24.camel@falcor> <4EC3CA9A.3070401@polito.it> <4EC40682.2050602@linux.vnet.ibm.com> <4EC4E89F.2060608@polito.it> <1321564518.21708.63.camel@falcor> <4EC63302.4040006@polito.it> <1321637471.2158.44.camel@falcor> <4ECA6595.7010406@polito.it> <1323041763.2061.22.camel@falcor> <4EDC9726.1040801@polito.it> <1323090236.2061.63.camel@falcor> <4EDCCD7D.7010406@polito.it> <1323118629.2061.117.camel@falcor> <4EDDEE15.3090200@polito.it> <1323181487.2165.35.camel@falcor> <4EDE2BC8.9080109@polito.it> <CALLzPKbGSFZgCUxKK26B6_JAC8oGJaXFXsJpefP0UvJ8LKPr8g@mail.gmail.com>
In-Reply-To: <CALLzPKbGSFZgCUxKK26B6_JAC8oGJaXFXsJpefP0UvJ8LKPr8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 02:33 PM, Kasatkin, Dmitry wrote:
> On Tue, Dec 6, 2011 at 4:50 PM, Roberto Sassu<roberto.sassu@polito.it>  wrote:
>> On 12/06/2011 03:24 PM, Mimi Zohar wrote:
>>>
>>> On Tue, 2011-12-06 at 11:27 +0100, Roberto Sassu wrote:
>>>>
>>>> On 12/05/2011 09:57 PM, Mimi Zohar wrote:
>>>>>
>>>>> On Mon, 2011-12-05 at 14:56 +0100, Roberto Sassu wrote:
>>>>>>
>>>>>> On 12/05/2011 02:03 PM, Mimi Zohar wrote:
>>>>>>>
>>>>>>> On Mon, 2011-12-05 at 11:04 +0100, Roberto Sassu wrote:
>>>>>>>
>>>>>>>> Hi Mimi
>>>>>>>>
>>>>>>>> i think moving this logic to the TPM driver (or in general, delaying
>>>>>>>> the action after the list mutex is unlocked) is not safe, because in
>>>>>>>> this way you are relying on the kernel trustworthiness to protect
>>>>>>>> itself and IMA against unmeasured potential attacks. So, the verifier
>>>>>>>> is unable to detect a kernel tampering that removed the limitation
>>>>>>>> on the TPM Quote operation.
>>>>>>>>
>>>>>>>> What i'm proposing in the patch:
>>>>>>>>
>>>>>>>> https://lkml.org/lkml/2011/11/21/202
>>>>>>>>
>>>>>>>> is in fact a new extension, which is triggered by a new kernel
>>>>>>>> parameter, so that the behaviour of the base IMA is not modified.
>>>>>>>
>>>>>>>
>>>>>>> How/why the TPM fails is important.  If the TPM fails because of an
>>>>>>> intermittent problem, then your solution of denying read/execute could
>>>>>>> work, but what would happen if it was persistent?  Would you be able
>>>>>>> to
>>>>>>> quiesce the system?
>>>>>>>
>>>>>>> As there is no way of differentiating a persistent from intermittent
>>>>>>> failure, both need to be addressed in the same manor.  For persistent
>>>>>>> TPM failure, we can not access the TPM to modify the PCR.  So what
>>>>>>> options do we have left?  My suggestion, though not optimal, prevents
>>>>>>> the IMA PCR from being quoted.
>>>>>>>
>>>>>>
>>>>>> Hi Mimi
>>>>>>
>>>>>> the solution you are proposing is reasonable as the default
>>>>>> behaviour, because not all IMA users need the high confidence
>>>>>> in the measurements, as ensured by denying the execution of
>>>>>> system calls.
>>>>>>
>>>>>> However, during the IMA initialization the TPM is tested
>>>>>> by issuing a PCR read (the test procedure may be extended
>>>>>> to better detect existing errors in advance). So, this means
>>>>>> that a TPM failure when the system is already powered on is
>>>>>> very unlikely and may cause serious issues as it could happen
>>>>>> if other devices are involved.
>>>>>>
>>>>>> For this reason, also my extension seems helpful especially
>>>>>> in the situations where all events need to be measured properly.
>>>>>> In this case, IMA users are aware that a TPM failure could hang
>>>>>> their systems, because they need to manually insert the required
>>>>>> kernel parameter.
>>>>>
>>>>>
>>>>> As you said a TPM failure is very unlikely, what type of attack are you
>>>>> trying to defend against, that could possibly warrant causing the system
>>>>> to hang?
>>>>>
>>>>
>>>> I don't know if this can really happen, but an attacker may issue
>>>> a lot of commands to the TPM, so that the timeout limit is reached
>>>> when IMA is trying to extend the PCR.
>>>>
>>>> Roberto Sassu
>>>
>>>
>>> Processing lots of commands isn't an issue, as IMA takes the
>>> ima_extend_list_mutex to synchronize adding the measurement to the
>>> measurement list and extending the PCR.  The TPM device driver takes the
>>> tpm_mutex, in tpm_transmit(), before transmitting the command.
>>>
>>
>> I mean issuing a lot of TPM commands, so that the TPM is unable
>> to process the IMA request.
>>
>>
>>
>>> So the issue remains whether an individual PCR extend can timeout/fail.
>>> As you previously said, this is highly unlikely.
>>>
>>
>> I think the question is whether or not an attacker can cause the
>> TPM to reach the timeout limit. If this is feasible and it cannot
>> be clearly detected by inspecting the measurements list, denying
>> the system call for which the measurement cannot be taken may be a solution.
>>
>> Roberto Sassu
>>
>>
>>
>>> Mimi
>>>
>
> If TPM is a separate HW module, it is often possible to make HW attack
> and modify parameters and return values,
> by accessing the bus.
>

Hi Dmitry

yes, this is another class of attacks that may also be used to
delay the execution of a command, so that the timeout limit will
be reached. However, probably we can do nothing if an attacker
can modify parameters or return values by accessing the hardware.

Roberto Sassu


> - Dmitry
>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

