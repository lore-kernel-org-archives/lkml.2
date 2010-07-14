Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0GNB4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:56:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54991 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0GNB4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vDTwQw7JKdeLfEH7ZQ4Hq5TF2gc/Zzf7vzbSGa/ZjSScXrh6pUMNSAi7SezTk6oRXw
         ESlWee7XjcxLXifOQyC1Ng/O6WDSCHEgWdnH7wn8aUP3gC5kYc1+PQJsxFXZ4MUVP0ae
         8CGpyNYUbFM7vHUEg5YpqCJvJfoSFfJXJQDFk=
Message-ID: <4C3D1942.1090207@gmail.com>
Date: Tue, 13 Jul 2010 19:56:18 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
        jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com> <4C3D101E.5010605@candelatech.com>
In-Reply-To: <4C3D101E.5010605@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:17 PM, Ben Greear wrote:
> On 07/13/2010 05:36 PM, Ben Greear wrote:
>> We're seeing boot failures on multiple machines, running FC8 and
>> F11. I bisected on an FC8 32-bit system. Newer hardware works,
>> but these older ones do not.
>>
>> A console log of the hang is found later in this email.
>>
>> Please let me know if you would like any additional information,
>> and I will be happy to test patches.
>>
>> The same failure happens in 2.6.34.1, so the fix does not appear to
>> be in the stable tree yet.
>
>
> I added some printks to the offending code. It seems the problem
> is that the fixed_bar_cap method in arch/x86/pci/mrst.c loops forever:
>
> # Endless loop of this spewing to console...
>
> pcie_cap: 268435456Checking vendor..
> pos after shift: 256
> Before read..

Can you print out bus->number and devfn and look that up in lspci to 
find out which device it's hitting? It looks like there's a device with 
a PCI Express extended capability header that has a extended capability 
ID of 0000h and a next capability offset of 100h, which points to 
itself, causing the infinite loop. I'm guessing that if pcie_cap >> 20 
<= pos then it should give up and break out of the loop, since it means 
that the next capability pointer is invalidly pointing to the same or a 
previous entry..
