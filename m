Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0LHSOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:14:45 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2366 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab0LHSOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:14:44 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Jian Peng" <jipeng@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>, "Robert Hancock" <hancockrwd@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Date: Wed, 8 Dec 2010 10:14:33 -0800
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: AcuWv7hXUFEReRUxRm+wOM2L6oM4dwAQUkqg
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org>
In-Reply-To: <4CFF58D2.4040006@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60E114A35RK10729169-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun,

The problem happened as follow:

After power up, inside ahci_init_one(), it will call ahci_power_up() to toggle PxCMD.SUD bit first, then HBA will send COMRESET to device, and device will send first D2H FIS back. Here it will call ahci_start_engine() to turn on PxCMD.ST to process command. In this case, it may run into race condition that transaction triggered by toggling PxCMD.SUD is not completed yet, and that is the reason why extra check is required by spec to guarantee that HBA already received FIS and in sane state. 

In most HBA, either staggered spin-up feature was not supported, or time required for transaction is less than that between two function calls, it may work. IMHO, this is a clear violation of spec, and not robust against all HBA design.

The major concern is that ahci_start_engine() is used widely in EH and it does not return result to reflect whether ST bit was set or not, this may cause trouble in some cases. I am working on verifying those cases with different HBAs now.

Thanks,
Jian


-----Original Message-----
From: Tejun Heo [mailto:tj@kernel.org] 
Sent: Wednesday, December 08, 2010 2:07 AM
To: Robert Hancock
Cc: Jian Peng; linux-kernel@vger.kernel.org; jgarzik@pobox.com; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

Hello,

On 12/08/2010 02:54 AM, Robert Hancock wrote:
> On 12/07/2010 01:43 AM, Jian Peng wrote:
>> Recently, while bringing up a new AHCI host controller, I found out
>> that current AHCI driver (in 2.6.37-rc3) may violate AHCI spec in
>> function libahci.c: ahci_start_engine().
>>
>> From end of section 10.1.2 in AHCI 1.3 spec, it claims
>>
>> Software shall not set PxCMD.ST to '1' until it is determined that
>> a functional device is present on the port as determined by
>> PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.
>>
>> It seems working well on most controller without this extra
>> checking, but does cause problem in our new core. Since toggling
>> PxCMD.SUD already initiated reset process at early time, and by the
>> time of ahci_start_engine() got called, BSY bit may not be cleared
>> yet, and forcing PxCMD.ST bit to 1 will cause problem for HW in
>> this case.

Hmmm... interesting.  Yeah, we have never had any problem in that area
and would like to avoid changing unless necessary but then again if
it's broken, well, we should.  What kind of problem is the controller
showing?

Thanks.

-- 
tejun


