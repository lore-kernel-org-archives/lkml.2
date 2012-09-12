Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab2ILQXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:23:40 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:43985 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453Ab2ILQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:23:38 -0400
Message-ID: <5050B708.5020308@akamai.com>
Date: Wed, 12 Sep 2012 11:23:36 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <1347403947-20187-1-git-send-email-johunt@akamai.com> <504FC2E9.4010708@akamai.com> <20120912085140.GA12277@aftab.osrc.amd.com> <5050824B.9050006@akamai.com> <5050857F.5060207@akamai.com> <20120912153016.GA12103@aftab.osrc.amd.com> <5050AC2E.3050408@akamai.com> <20120912154943.GB12103@aftab.osrc.amd.com>
In-Reply-To: <20120912154943.GB12103@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:49 AM, Borislav Petkov wrote:
>
> Yes, that's because the whole init_csrows thing has been b0rked since
> forever. In your case, amd64_csrow_nr_pages() should pay attention to
> the dct (second argument) which on K8 is always 0 (we have only one DCT
> aka Dram ConTroller on K8) and the function should return 0 if dct is 1.
> But the whole loop in init_csrows is fishy too so I'll need to rework
> that properly. Oh well...
>
Looks like we're seeing an issue on another machine. Still 0Fh family, 
but the model is reported as 2, with cs_mode 7. This causes the machine 
to report that it has 32GB memory instead of 4GB. For this issue it 
seems like the shift logic is incorrect. Looking at the old 
ddr2_dbam_revD table it doesn't really lend itself to shifting very 
easily. Perhaps something like this (albeit very ugly - it matches the 
old table):

/* 3 to 5 */
if ( cs_mode > 2 && cs_mode < 6 )
	return 32 << (cs_mode - 1);
/* 6 to 8 */
else if ( cs_mode > 5 && cs_mode < 9 )
	return 32 << (cs_mode - 3);
/* 9 and 10 */
else if ( cs_mode > 8 )
	return 32 << (cs_mode - 4);
/* 0 to 3 */
else
	return 32 << cs_mode;

Josh
