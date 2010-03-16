Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab0CPN0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:26:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:53933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CPN0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=jPQ1Uqjax2YhlSR3DTWQd1wxt8FOLwkIuxMWjdkEdFhvpBKRu3wtReHNtJ6jmqmMpB
         FRB8AOKOStV/aB4ZG1q3hOwd47ryfozmOjqLPtV5rTiRBNUM+trmniWWy9Ag7fwWr1T0
         hdCSctLA+hK0uSv2Pwkv+b2ZibsDov9iFjOz4=
Message-ID: <4B9F86E9.2030702@gmail.com>
Date: Tue, 16 Mar 2010 14:26:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.4 Thunderbird/3.1b1
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: regd: sleeping in atomic
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanse found an atomic error in reg_copy_regd:

static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
                          const struct ieee80211_regdomain *src_regd)
{
         struct ieee80211_regdomain *regd;
         int size_of_regd = 0;
         unsigned int i;

         size_of_regd = sizeof(struct ieee80211_regdomain) +
           ((src_regd->n_reg_rules + 1) * sizeof(struct 
ieee80211_reg_rule));

         regd = kzalloc(size_of_regd, GFP_KERNEL);       <---- here

Called from:

static void reg_regdb_search(struct work_struct *work)
{
         spin_lock(&reg_regdb_search_lock);
         while (!list_empty(&reg_regdb_search_list)) {
...
                 for (i=0; i<reg_regdb_size; i++) {
                         curdom = reg_regdb[i];

                         if (!memcmp(request->alpha2, curdom->alpha2, 2)) {
                                 r = reg_copy_regd(&regdom, curdom);
...
         spin_unlock(&reg_regdb_search_lock);
}

Whole error temporarily available at:
http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=34-rc&id=578

It is introduced by 3b377ea9d4efc94dc52fe41b4dfdb463635ab298.

Do you plan to extend it somehow or may the spinlock be converted to 
mutex? If not how much may size_of_regd be -- can we safely switch to 
GFP_ATOMIC?

-- 
js
