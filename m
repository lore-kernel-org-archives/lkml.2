Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1LUSK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:10:56 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:20529
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab1LUSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:10:55 -0500
X-SpamScore: -6
X-BigFish: PS-6(zz1432Nzz1202hzzz2fh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT004.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4EF22127.3060905@ixiacom.com>
Date: Wed, 21 Dec 2011 10:10:47 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RFC: Inconsistent short read behaviour in __do_proc_dointvec vs _proc_do_string
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT004.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT004.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should repeated short reads in __do_proc_dointvec behave consistently with _proc_do_string ?

Consider:

>     char c[1];
>     int n;
> 
>     while (1)
>     {
>         n = read(0, c, 1);
> 
>         if (n <= 0) break;
> 
>         write (1, c, 1);
>     }

Running this program on /proc/self/stat emits the expected output.

Running this program on /proc/sys/kernel/random/poolsize does not :-(

The issue is that __do_proc_dointvec does not accommodate non-zero file positions
when reading:

>         if (!tbl_data || !table->maxlen || !*lenp || (*ppos && !write)) {
>                *lenp = 0;
>                return 0;
>         }


OTOH _proc_do_string seems quite willing to accommodate it:

>         if (write) {
>            ...
>         } else {
>            len = strlen(data);
>            if (len > maxlen)
>                     len = maxlen;
>
>            if (*ppos > len) {
>                     *lenp = 0;
>                     return 0;
>            }


Should __do_proc_intvec behave more like _proc_do_string, or vice-versa ?


Earl


