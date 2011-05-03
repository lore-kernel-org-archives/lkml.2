Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1ECOsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:48:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1ECOs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:48:27 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=3rvgeqzMqd0A:10 a=HRYr7rpUo_YA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=YYF7fsvRAAAA:8 a=yQdBAQUQAAAA:8 a=n9Sqmae0AAAA:8 a=jbzjR8Xh46KCUUp7ZCUA:9 a=qsBijOwxkLpvqAUyzK8A:7 a=CjuIK1q_8ugA:10 a=oX6Vh0_dJjoA:10 a=IcxpeKGZWnEA:10 a=z0jh1eRXt18A:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 03 May 2011 09:48:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        chaoming_li@realsil.com.cn
Subject: [PATCH 05/12] rtlwifi: rtl8192se: Merge led routines
Message-ID: <4dc015b9.jr0NACuUzKzGcRr1%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chaoming Li <chaoming_li@realsil.com.cn>

Merge routines led.c and led.h for RTL8192SE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.c
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.c
@@ -0,0 +1,149 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../pci.h"
+#include "reg.h"
+#include "led.h"
+
+static void _rtl92se_init_led(struct ieee80211_hw *hw,
+			      struct rtl_led *pled, enum rtl_led_pin ledpin)
+{
+	pled->hw = hw;
+	pled->ledpin = ledpin;
+	pled->ledon = false;
+}
+
+void rtl92se_init_sw_leds(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	_rtl92se_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
+	_rtl92se_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+}
+
+void rtl92se_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
+{
+	u8 ledcfg;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
+		 ("LedAddr:%X ledpin=%d\n", LEDCFG, pled->ledpin));
+
+	ledcfg = rtl_read_byte(rtlpriv, LEDCFG);
+
+	switch (pled->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0xf0);
+		break;
+	case LED_PIN_LED1:
+		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0x0f);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("switch case not process\n"));
+		break;
+	}
+	pled->ledon = true;
+}
+
+void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	u8 ledcfg;
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
+		 ("LedAddr:%X ledpin=%d\n", LEDCFG, pled->ledpin));
+
+	ledcfg = rtl_read_byte(rtlpriv, LEDCFG);
+
+	switch (pled->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		ledcfg &= 0xf0;
+		if (pcipriv->ledctl.led_opendrain == true)
+			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(1)));
+		else
+			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
+		break;
+	case LED_PIN_LED1:
+		ledcfg &= 0x0f;
+		rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("switch case not process\n"));
+		break;
+	}
+	pled->ledon = false;
+}
+
+static void _rtl92se_sw_led_control(struct ieee80211_hw *hw,
+				    enum led_ctl_mode ledaction)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	switch (ledaction) {
+	case LED_CTL_POWER_ON:
+	case LED_CTL_LINK:
+	case LED_CTL_NO_LINK:
+		rtl92se_sw_led_on(hw, pLed0);
+		break;
+	case LED_CTL_POWER_OFF:
+		rtl92se_sw_led_off(hw, pLed0);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtl92se_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	if ((ppsc->rfoff_reason > RF_CHANGE_BY_PS) &&
+	    (ledaction == LED_CTL_TX ||
+	    ledaction == LED_CTL_RX ||
+	    ledaction == LED_CTL_SITE_SURVEY ||
+	    ledaction == LED_CTL_LINK ||
+	    ledaction == LED_CTL_NO_LINK ||
+	    ledaction == LED_CTL_START_TO_LINK ||
+	    ledaction == LED_CTL_POWER_ON)) {
+		return;
+	}
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, ("ledaction %d,\n",
+		 ledaction));
+
+	_rtl92se_sw_led_control(hw, ledaction);
+}
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.h
@@ -0,0 +1,37 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_PCI92SE_LED_H__
+#define __REALTEK_PCI92SE_LED_H__
+
+void rtl92se_init_sw_leds(struct ieee80211_hw *hw);
+void rtl92se_sw_led_on(struct ieee80211_hw *hw,	struct rtl_led *pled);
+void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92se_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
+
+#endif
